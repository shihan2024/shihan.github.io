<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
    int tableNumber = Integer.parseInt(request.getParameter("tableNumber"));
    int id = Integer.parseInt(request.getParameter("id"));

    try {
    	Connection conn = DriverManager.getConnection("jdbc:mysql://172.20.10.2/ordering?", "root", "12345678");
        PreparedStatement pstmtUpdate = conn.prepareStatement("UPDATE tables SET status = 'Available' WHERE restaurant_id = ? AND table_number = ? ");
        pstmtUpdate.setInt(1,restaurantId );
        pstmtUpdate.setInt(2,tableNumber );
        pstmtUpdate.executeUpdate();

        PreparedStatement pstmtUpdate2 = conn.prepareStatement("UPDATE orders SET status = 'no' WHERE restaurant_id = ? AND table_number = ? AND status = 'yes'");
        pstmtUpdate2.setInt(1, restaurantId);
        pstmtUpdate2.setInt(2, tableNumber);
        int rowsAffected = pstmtUpdate2.executeUpdate();
        int orderId = 0;
        if (rowsAffected > 0) {
            PreparedStatement pstmtSelect = conn.prepareStatement("SELECT order_id FROM orders WHERE restaurant_id = ? AND table_number = ?");
            pstmtSelect.setInt(1, restaurantId);
            pstmtSelect.setInt(2, tableNumber);
            ResultSet rs = pstmtSelect.executeQuery();
            if (rs.next()) {
                orderId = rs.getInt("order_id");
            }
        }
        PreparedStatement pstmt4 = conn.prepareStatement("DELETE FROM order_items WHERE order_id = ? AND status IN ('uncommitted', 'before', 'during')");
        pstmt4.setInt(1, orderId);
        pstmt4.executeUpdate();

        response.sendRedirect("frontDesk.jsp?id=" + id );

        conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
</body>
</html>