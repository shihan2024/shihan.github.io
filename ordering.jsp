<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html >
<html>
<head>
    <title>点菜页面</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f8f8;
            margin: 0;
            padding: 0;
        }

        h1 {
            text-align: left;
            margin-top: 20px;
            color: #333;
        }

        .order-info {
            margin-top: 20px;
            padding-left: 20px;
        }

        .menu-item {
             width: 80%;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
             width: 20rem;
            width: 30rem;
        }

        .menu-item img {
            width: 100px;
            height: 100px;
            margin-right: 20px;
        }

        .menu-item h3 {
            margin-top: 0;
        }

        .continue-button {
            text-decoration: none;
            color: #fff;
            background-color: #007bff;
            padding: 10px 20px;
            border-radius: 5px;
            text-align: left;
        }
        .delisted-button {
            text-decoration: none;
            color: #fff;
            background-color: #007bff;
            padding: 10px 20px;
            border-radius: 5px;
            text-align: left;
        }

    </style>
</head>
<body>
<div class="menu-item">
<h1>我的购物车</h1>
<%
    int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
    int tableNumber = Integer.parseInt(request.getParameter("tableNumber"));

    try {
    	Connection conn = DriverManager.getConnection("jdbc:mysql://172.20.10.2/ordering?", "root", "12345678");

        PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM Orders WHERE status = 'yes' AND table_number = ? AND restaurant_id = ?");
        pstmt.setInt(1, tableNumber);
        pstmt.setInt(2, restaurantId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            int orderId = rs.getInt("order_id");

            PreparedStatement pstmt2 = conn.prepareStatement("SELECT * FROM Order_items WHERE Order_id = ?  AND status = 'uncommited'");
            pstmt2.setInt(1, orderId);
            ResultSet rs2 = pstmt2.executeQuery();

            while (rs2.next()) {
                int itemId = rs2.getInt("item_id");
                PreparedStatement pstmt3 = conn.prepareStatement("SELECT * FROM menu_items WHERE item_id = ? AND restaurant_id = ? ");

                pstmt3.setInt(1, itemId);
                pstmt3.setInt(2, restaurantId);
                ResultSet rs3 = pstmt3.executeQuery();
                rs3.next();
                String name = rs3.getString("name");
                String image = rs3.getString("url");
                double price = rs3.getDouble("price");
                String status = rs2.getString("status");
%>

    <img src="<%= image %>" alt="<%= name %>">
    <h2><%= name %></h2>
    <p>价格: <%= price %> 元</p><br>
    <a href="delete.jsp?tableNumber=<%=tableNumber%>&restaurantId=<%=restaurantId%>&itemId=<%=itemId%>" class="continue-button" role="button">取消</a>
</div>
<%
    }
%><a href="submission.jsp?&orderId=<%=orderId%>&tableNumber=<%=tableNumber%>&restaurantId=<%=restaurantId%>" class="continue-button" role="button">下单</a><%
    }

%>

<h1>点菜页面</h1>
<div class="order-info">
    <%
        PreparedStatement pstmt4 = conn.prepareStatement("SELECT name, location FROM restaurants WHERE restaurant_id = ?");
        pstmt4.setInt(1, restaurantId);
        ResultSet rs4 = pstmt4.executeQuery();
        rs4.next();

        PreparedStatement pstmt5 = conn.prepareStatement("SELECT * FROM Menu_Items WHERE restaurant_id = ?");
        pstmt5.setInt(1, restaurantId);
        ResultSet rs5 = pstmt5.executeQuery();

        while (rs5.next()) {
            String itemName = rs5.getString("name");
            String itemURL = rs5.getString("url");
            double itemPrice = rs5.getDouble("price");
            String itemCategory = rs5.getString("category");
            int itemId = rs5.getInt("item_id");
    %>
    <div class="menu-item">
        <img src="<%= itemURL %>" alt="<%= itemName %>">
        <div>
            <h3><%= itemName %></h3>
            <p><strong>价格:￥</strong> <%= itemPrice %></p>
            <p><strong>分类:</strong> <%= itemCategory %></p>
        </div>
        <%if(rs5.getString("status").equals("Available")){
    %>
        <a href="add.jsp?tableNumber=<%=tableNumber%>&restaurantId=<%=restaurantId%>&itemId=<%=itemId%>" class="continue-button" role="button">+</a>
        <%}else{ %>
        <a class="delisted-button" role="button">已下架</a>
        <% }%>
    </div>
    <%
            }
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();}
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