<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html >
<html>
<head>
    <meta charset="UTF-8">
    <title>饭店查询</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 80%;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #333;
        }
        .restaurant {
            display: flex;
            align-items: center;
            padding: 10px;
            border-bottom: 1px solid #ccc;
        }
        .restaurant img {
            width: 100px;
            height: 100px;
            margin-right: 20px;
            border-radius: 5px;
        }
        .restaurant .info {
            flex: 1;
        }
        .restaurant h2 {
            margin: 0 0 5px 0;
            color: #333;
        }
        .restaurant p {
            margin: 0;
            color: #666;
        }
    </style>
</head>
<body>
<h1>饭店查询</h1>
<hr>
<form method="post" >
    <input type="text" name="kw"/>
    <input type="submit" value="查询"/>

</form>
<div>
    <%
        request.setCharacterEncoding("utf-8");
        String key=request.getParameter("kw");
        if(key!=null){
            try {
                //构造sql
                String sql="SELECT * FROM restaurants WHERE location like '%" + key + "%' or name LIKE '%" + key + "%' or description like '%" + key + "%'";
                //out.println(sql);
                //out.println("<br>");

                //查询db
                Class.forName("org.mariadb.jdbc.Driver");
                Connection connection = DriverManager.getConnection("jdbc:mysql://172.20.10.2/ordering?", "root", "12345678");
                Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(sql);

                //显示查询结果
                while(rs.next()) {
                    String name = rs.getString("name");
                    String location = rs.getString("location");
                    String description = rs.getString("description");
                    String image = rs.getString("image");
    %>
    <div class="restaurant">
        <img src="<%= image %>" alt="<%= name %>">
        <div class="info">
            <h2><%= name %></h2>
            <p><strong>Location:</strong> <%= location %></p>
            <p><%= description %></p>
        </div>
    </div>
    <%
                }

                //关闭连接
                rs.close();
                stmt.close();
                connection.close();
            } catch(Exception e) {
                out.println("An error occurred: " + e.getMessage());
            }
        } else {
            out.println("Please provide a search keyword.");
        }
    %>
</div>
</body>
</html>