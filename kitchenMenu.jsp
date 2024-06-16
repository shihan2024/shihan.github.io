<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>制作菜品</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: center;
        }
        .image-cell {
            width: 50px; /* 设置图片列的宽度 */
        }
    </style>
</head>
<body>
<%int id = Integer.parseInt(request.getParameter("id")); %>
<jsp:include page="topBarKitchen.jsp?id=<%= id %>" />
<h2>准备制作</h2>
<%
    try {
    	Connection conn = DriverManager.getConnection("jdbc:mysql://172.20.10.2/ordering?", "root", "12345678");

        PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM account WHERE id = ?");
        pstmt.setInt(1, id);
        ResultSet rs = pstmt.executeQuery();
        int restaurant_id;
        if (rs.next()) {
            restaurant_id = rs.getInt("restaurant_id");
        } else {
            throw new SQLException("无法获取生成的订单ID");
        }

        // 显示准备制作的订单
        PreparedStatement pstmt2 = conn.prepareStatement("SELECT * FROM menu_items WHERE restaurant_id = ?");
        pstmt2.setInt(1, restaurant_id);
        ResultSet rs2 = pstmt2.executeQuery();

        out.println("<table>");
        out.println("<tr><th class='image-cell'>图片</th><th>菜名</th><th>桌号</th><th>操作</th></tr>");

        while (rs2.next()) {
            int item_id = rs2.getInt("item_id");
            String name = rs2.getString("name");
            String imageUrl = rs2.getString("url"); // 获取图片链接

            PreparedStatement pstmt3 = conn.prepareStatement("SELECT * FROM order_items WHERE item_id = ? AND status = 'before'");
            pstmt3.setInt(1, item_id);
            ResultSet rs3 = pstmt3.executeQuery();

            while (rs3.next()) {
                int order_id = rs3.getInt("order_id");

                PreparedStatement pstmt4 = conn.prepareStatement("SELECT * FROM orders WHERE order_id = ?");
                pstmt4.setInt(1, order_id);
                ResultSet rs4 = pstmt4.executeQuery();

                while (rs4.next()) {
                    int table_number = rs4.getInt("table_number");
                    out.println("<tr><td><img src='" + imageUrl + "' width='100' height='100'></td><td>" + name + "</td><td>" + table_number + "</td><td><a href='cook.jsp?orderId=" + order_id + "&itemId=" + item_id + "&id=" + id+ "'><button>上菜</button></a></td></tr>");
                }
            }
        }
        out.println("</table>");


        // 显示正在制作的订单
        PreparedStatement pstmt5 = conn.prepareStatement("SELECT * FROM menu_items WHERE restaurant_id = ?");
        pstmt5.setInt(1, restaurant_id);
        ResultSet rs5 = pstmt5.executeQuery();

        out.println("<h2>正在制作</h2>");
        out.println("<table>");
        out.println("<tr><th class='image-cell'>图片</th><th>菜名</th><th>桌号</th><th>操作</th></tr>");

        while (rs5.next()) {
            int item_id = rs5.getInt("item_id");
            String name = rs5.getString("name");
            String imageUrl = rs5.getString("url"); // 获取图片链接

            PreparedStatement pstmt6 = conn.prepareStatement("SELECT * FROM order_items WHERE item_id = ? AND status = 'during'");
            pstmt6.setInt(1, item_id);
            ResultSet rs6 = pstmt6.executeQuery();

            while (rs6.next()) {
                int order_id = rs6.getInt("order_id");

                PreparedStatement pstmt7 = conn.prepareStatement("SELECT * FROM orders WHERE order_id = ?");
                pstmt7.setInt(1, order_id);
                ResultSet rs7 = pstmt7.executeQuery();

                while (rs7.next()) {
                    int table_number = rs7.getInt("table_number");
                    out.println("<tr><td><img src='" + imageUrl + "' width='100' height='100'></td><td>" + name + "</td><td>" + table_number + "</td><td><a href='servingDishes.jsp?orderId=" + order_id + "&itemId=" + item_id + "&id=" + id+ "'><button>上菜</button></a></td></tr>");                }
            }
        }
        out.println("</table>");

        conn.close();
    } catch (SQLException e) {
        out.println("发生错误: " + e.getMessage());
        e.printStackTrace();
    }
%>

</body>
</html>