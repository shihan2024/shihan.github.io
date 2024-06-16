<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<body>
<%
    int orderId = Integer.parseInt(request.getParameter("orderId"));
    int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
    int tableNumber = Integer.parseInt(request.getParameter("tableNumber"));
    try {
    	Connection conn = DriverManager.getConnection("jdbc:mysql://172.20.10.2/ordering?", "root", "12345678");
        PreparedStatement pstmt = conn.prepareStatement("UPDATE order_items SET status = 'before' WHERE status = 'uncommited' AND order_id = ?;");
        pstmt.setInt(1, orderId);
        pstmt.executeUpdate();

        response.sendRedirect("order.jsp?tableNumber=" + tableNumber+ "&restaurantId=" + restaurantId );

        conn.close();
    } catch (SQLException e) {
        e.printStackTrace();}
%>
</div>
</body>
</body>
</html>