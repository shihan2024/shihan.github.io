<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <!DOCTYPE html>
    <html>
    <head>
        <title>选择桌号</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f8f8f8;
                margin: 0;
                padding: 0;
            }

            h1 {
                text-align: center;
                margin-top: 20px;
                color: #333;
            }

            .table-list {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                 width: 20rem;
            width: 30rem;
            }

            .table {
                margin: 10px;
            }

            .table-button {
                background-color: #4CAF50;
                border: none;
                color: white;
                padding: 15px 32px;
                text-align: center;
                text-decoration: none;
                display: inline-block;
                font-size: 16px;
                margin: 4px 2px;
                cursor: pointer;
                border-radius: 10px;
                transition-duration: 0.4s;
            }

            .table-button:hover {
                background-color: #45a049;
            }
            .table2 {
                margin: 10px;
            }

            .table2-button {
                background-color: #929292;
                border: none;
                color: white;
                padding: 15px 32px;
                text-align: center;
                text-decoration: none;
                display: inline-block;
                font-size: 16px;
                margin: 4px 2px;
                cursor: pointer;
                border-radius: 10px;
                transition-duration: 0.4s;
            }

            .table2-button:hover {
                background-color: #929292;
            }
        </style>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="refresh" content="2">
    </head>
<body>
<h1>请选择桌号</h1>
<div class="table-list">
    <%
        // 获取从上一个页面传递过来的餐馆 ID
        int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));

        try {
            // 建立数据库连接
            Connection conn = DriverManager.getConnection("jdbc:mysql://172.20.10.2/ordering?", "root", "12345678");

            // 使用预处理语句查询特定餐馆的桌号
            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM tables WHERE restaurant_id = ?");
            pstmt.setInt(1, restaurantId);
            ResultSet rs = pstmt.executeQuery();

            // 遍历结果集并显示桌号
            while (rs.next()) {
                int tableNumber = rs.getInt("table_number");
                String status = rs.getString("status");
                if (status.equals("Available")){
    %>
    <div class="table">
        <form action="order.jsp" method="GET">
            <input type="hidden" name="restaurantId" value="<%= restaurantId %>">
            <button type="submit" class="table-button" name="tableNumber" value="<%= tableNumber %>">桌号 <%= tableNumber %></button>
        </form>
    </div>
    <%
    }
    else{
    %>
    <div class="table2">
        <form method="GET">
            <input type="hidden" name="restaurantId" value="<%= restaurantId %>">
            <button type="submit" class="table2-button" name="tableNumber" value="<%= tableNumber %>">桌号 <%= tableNumber %></button>
        </form>
    </div>
    <%
                }

            }
            // 关闭数据库连接
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
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
