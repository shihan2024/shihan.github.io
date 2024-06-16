<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>选择餐馆</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 80%;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
             width: 20rem;
            width: 30rem;
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        .restaurant {
            display: flex;
            align-items: center;
            padding: 20px;
            border-bottom: 1px solid #ccc;
        }

        .restaurant img {
            width: 120px;
            height: 120px;
            margin-right: 20px;
            border-radius: 10px;
            object-fit: cover;
        }

        .restaurant .info {
            flex: 1;
        }

        .restaurant h2 {
            margin: 0 0 10px 0;
            color: #333;
            font-size: 1.5em;
        }

        .restaurant p {
            margin: 0;
            color: #666;
            line-height: 1.5;
        }

        a {
            text-decoration: none;
            color: #007bff;
        }

        a:hover {
            text-decoration: underline;
            color: #0056b3;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>选择餐馆</h1>
    <%
        try {
            // Connect to the database
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection("jdbc:mysql://172.20.10.2/ordering?", "root", "12345678");
            Statement stmt = connection.createStatement();

            ResultSet rs = stmt.executeQuery("SELECT * FROM Restaurants");

            while(rs.next()) {
                String name = rs.getString("name");
                String location = rs.getString("location");
                int id = rs.getInt("restaurant_id");
                String image = rs.getString("image_url");
    %>
    <div class="restaurant">
        <img src="<%= image %>" alt="<%= name %>">
        <div class="info">
            <h2><a href="tableSelection.jsp?restaurantId=<%= id %>"><%= name %></a></h2>
            <p><strong>Location:</strong> <%= location %></p>
        </div>
    </div>
    <%
            }

            // Close the connection
            rs.close();
            stmt.close();
        } catch(Exception e) {
            out.println("An error occurred: " + e.getMessage());
        }
    %>
</div>
</body>
<script>
    function flexible(){
        var docEl = documentElement;
        var rem = docEl.clientWidth/10;
        docEl.style.fontSize = rem + 'px';
    }
    flexible();
    window.addEventListener('resize',flexible);
</script>
</html>