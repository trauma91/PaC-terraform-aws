resource "aws_ecr_repository" "ecr_empatica" {
  name                 = "ecr_empatica"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_cluster" "cpalese_empatica" {
  name = "${var.cluster_name}"
}

resource "aws_ecs_task_definition" "be" {
  family                   = "${var.task_be_name}"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${var.container_be_name}",
      "image": "${aws_ecr_repository.ecr_empatica.repository_url}:${var.docker_image_tag}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 9000
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_service" "backend_service" {
  name            = "${var.service_be_name}"                     
  cluster         = "${aws_ecs_cluster.cpalese_empatica.id}"   #Cluster where this service will be run 
  task_definition = "${aws_ecs_task_definition.be.arn}"        #Tasks executed into this service
  launch_type     = "FARGATE"
  desired_count   = 3

  load_balancer {
    target_group_arn = "${aws_lb_target_group.target_group.arn}"
    container_name   = "${aws_ecs_task_definition.be.family}"
    container_port   = 9000
  }

  network_configuration {
    subnets          = ["${aws_default_subnet.default_subnet_a.id}",
                        "${aws_default_subnet.default_subnet_b.id}",
                        "${aws_default_subnet.default_subnet_c.id}"]
    assign_public_ip = true
    security_groups  = ["${aws_security_group.service_security_group.id}"]
  }

  depends_on = ["aws_lb_target_group.target_group"]
}

resource "aws_default_vpc" "default_vpc" {
}

resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "eu-west-1a"
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = "eu-west-1b"
}

resource "aws_default_subnet" "default_subnet_c" {
  availability_zone = "eu-west-1c"
}

resource "aws_security_group" "service_security_group" {
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allowing any outgoing protocol 
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}