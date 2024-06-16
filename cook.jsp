<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    int orderId = Integer.parseInt(request.getParameter("orderId"));
    int itemId = Integer.parseInt(request.getParameter("itemId"));
    int id = Integer.parseInt(request.getParameter("id"));

    try {
    	Connection conn = DriverManager.getConnection("jdbc:mysql://172.20.10.2/ordering?", "root", "12345678");

        PreparedStatement pstmt = conn.prepareStatement("UPDATE order_items SET STATUS = 'during' WHERE item_id = ? AND order_id = ? AND STATUS = 'before' LIMIT 1");
        pstmt.setInt(1, itemId);
        pstmt.setInt(2, orderId);
        pstmt.executeUpdate(); // 使用 executeUpdate() 执行更新操作

        response.sendRedirect("kitchenMenu.jsp?id=" + id);

        conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
</body>
</html>