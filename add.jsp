<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %><%@ page import="java.time.*" %>
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
        int orderId;
        if (rs.next()) {
            orderId = rs.getInt("order_id");
        }else {
            PreparedStatement pstmtUpdate = conn.prepareStatement("UPDATE tables SET status = 'unavailable' WHERE restaurant_id = ? AND table_number = ? ");
            pstmtUpdate.setInt(1,restaurantId );
            pstmtUpdate.setInt(2,tableNumber );
            pstmtUpdate.executeUpdate();

            PreparedStatement pstmtInsert = conn.prepareStatement("INSERT INTO Orders (status, table_number, restaurant_id, created_at) VALUES ('yes', ?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
            pstmtInsert.setInt(1, tableNumber);
            pstmtInsert.setInt(2, restaurantId);
            pstmtInsert.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            pstmtInsert.executeUpdate();

            ResultSet generatedKeys = pstmtInsert.getGeneratedKeys();
            if (generatedKeys.next()) {
                orderId = generatedKeys.getInt(1); // 获取生成的订单ID
            } else {
                throw new SQLException("无法获取生成的订单ID");
            }
        }
        PreparedStatement pstmt4 = conn.prepareStatement("INSERT INTO order_items (item_id, order_id) VALUES (?, ?)");
        pstmt4.setInt(1, itemId);
        pstmt4.setInt(2, orderId);
        pstmt4.executeUpdate();
        response.sendRedirect("ordering.jsp?tableNumber=" + tableNumber+ "&restaurantId=" + restaurantId );

            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();}
%>
</div>
</body>
</body>
</html>
