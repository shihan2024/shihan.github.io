<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %><%@ page import="java.time.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>已点菜品</title>
    <style>
        body {
            background-color: #f8f8f8;
            margin: 0;
            padding: 0;
        }

        h1 {
            text-align: left;
            margin-top: 20px;
            color: #333;
        }

        .ordered-items {
            margin-top: 20px;
            padding-left: 20px;
             width: 20rem;
            width: 30rem;
        }

        .continue-button {
            text-decoration: none;
            color: #fff;
            background-color: #007bff;
            padding: 10px 20px;
            border-radius: 5px;
        }

        .ordered-item h3 {
            margin-top: 0;
            margin-right: 20px;
        }

        .ordered-item p {
            margin-right: 20px;
        }

        .menu-item {
            display: flex;
            align-items: center;
            border: 1px solid #ccc;
            padding: 10px;
            margin: 10px 20px;
            background-color: #fff;
            border-radius: 5px;
        }

        .menu-item img {
            width: 100px;
            height: 100px;
            margin-right: 20px;
        }

        .menu-item h3 {
            margin-top: 0;
        }

        .back-button {
            margin-top: 20px;
            text-align: center;
        }

        .back-button a {
            text-decoration: none;
            color: #fff;
            background-color: #007bff;
            padding: 10px 20px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
<h1>已点菜品</h1>
<div class="ordered-items">
    <%
        int tableNumber = Integer.parseInt(request.getParameter("tableNumber"));
        int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));

        try {
        	Connection conn = DriverManager.getConnection("jdbc:mysql://172.20.10.2/ordering?", "root", "12345678");

            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM Orders WHERE status = 'yes' AND table_number = ? AND restaurant_id = ?");
            pstmt.setInt(1, tableNumber);
            pstmt.setInt(2, restaurantId);
            ResultSet rs = pstmt.executeQuery();
            int orderId;
            if (rs.next()) {
                orderId = rs.getInt("order_id");
            } else {
                throw new SQLException("无法获取生成的订单ID");
            }

            PreparedStatement pstmt2 = conn.prepareStatement("SELECT * FROM Order_items WHERE Order_id = ? AND STATUS IN ('after','before','during')");
            pstmt2.setInt(1, orderId);
            ResultSet rs2 = pstmt2.executeQuery();

            while (rs2.next()) {
            int itemId = rs2.getInt("item_id");
            PreparedStatement pstmt3 = conn.prepareStatement("SELECT * FROM `menu_items` WHERE item_id = ? AND restaurant_id = ?  ");
            pstmt3.setInt(1, itemId);
            pstmt3.setInt(2, restaurantId);
            ResultSet rs3 = pstmt3.executeQuery();
            rs3.next();
                String name = rs3.getString("name");
                String image = rs3.getString("url");
                double price = rs3.getDouble("price");
                String status = rs2.getString("status");
                switch (status) {
                    case "before":
                        status = "未制作";
                        break;
                    case "during":
                        status = "制作中";
                        break;
                    case "after":
                        status = "制作完成";
                        break;
                }
    %>
        <div class="menu-item">
            <img src="<%= image %>" alt="<%= name %>">
            <h2><%= name %></h2>
            <p>价格: <%= price %> 元</p><br>
            <p>状态: <%= status %></p>
            <% if (status.equals("未制作")) { %>
            <a href="cancel.jsp?itemId=<%=itemId%>&orderId=<%=orderId%>&tableNumber=<%=tableNumber%>&restaurantId=<%=restaurantId%>&id=0" class="continue-button" role="button">退菜</a>
            <%} %>
        </div>
    <%}
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    %>
        <a href="ordering.jsp?tableNumber=<%=tableNumber%>&restaurantId=<%=restaurantId%>" class="continue-button" role="button">继续点菜</a>
        </div>
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