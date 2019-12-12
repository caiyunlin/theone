# 数据库连接字符串

Server=localhost;Database=MY_DB;Integrated Security=True  # 集成方式认证
Server=localhost;Database=MY_DB;User ID=sa;Password=sa  # SQL 认证

# 创建表格脚本
create table t_user(
    us_id int identity,
    us_name varchar(500) not null,
    us_email varchar(500) null
)



