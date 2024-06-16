<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<body>
<%
    int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
    int tableNumber = Integer.parseInt(request.getParameter("tableNumber"));
    int itemId = Integer.parseInt(request.getParameter("itemId"));

    try {
    	Connection conn = DriverManager.getConnection("jdbc:mysql://172.20.10.2/ordering?", "root", "12345678");

        PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM Orders WHERE status = 'yes' AND table_number = ? AND restaurant_id = ?");
        pstmt.setInt(1, tableNumber);
        pstmt.setInt(2, restaurantId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            int orderId = rs.getInt("order_id");

            PreparedStatement pstmt4 = conn.prepareStatement("DELETE FROM order_items WHERE item_id = ? AND order_id = ? LIMIT 1");
            pstmt4.setInt(1, itemId);
            pstmt4.setInt(2, orderId);
            pstmt4.executeUpdate();
            response.sendRedirect("ordering.jsp?tableNumber=" + tableNumber+ "&restaurantId=" + restaurantId );

        }

        conn.close();
    } catch (SQLException e) {
        e.printStackTrace();}
%>
</div>
</body>
</body>
</html>
