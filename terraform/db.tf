resource "aws_db_instance" "empatica_db" {
  allocated_storage         = 10
  storage_type              = "gp2"
  engine                    = "mysql"
  engine_version            = "5.7"
  instance_class            = "db.t2.micro"
  name                      = "${var.db_name}"
  username                  = "${var.db_username}"
  password                  = "${var.db_password}"
  parameter_group_name      = "default.mysql5.7"
  final_snapshot_identifier = "${var.db_name}-backup"
}