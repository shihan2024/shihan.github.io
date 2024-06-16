<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>订单查看</title>
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
    .order-header {
      background-color: #f2f2f2;
    }
    .order-details {
      background-color: #e6e6e6;
    }
    .total-price {
      font-weight: bold;
    }
  </style>
</head>
<body>
<%int id = Integer.parseInt(request.getParameter("id")); %>
<jsp:include page="topBar.jsp?id=<%= id %>" />

<%
  try {
	  Connection conn = DriverManager.getConnection("jdbc:mysql://172.20.10.2/ordering?", "root", "12345678");

    PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM account WHERE id = ?");
    pstmt.setInt(1, id);
    ResultSet rs = pstmt.executeQuery();
    int restaurant_id;
    if (rs.next()) {
      restaurant_id = rs.getInt("restaurant_id");
      PreparedStatement pstmt2 = conn.prepareStatement("SELECT * FROM orders WHERE restaurant_id = ? AND status ='no'");
      pstmt2.setInt(1, restaurant_id);
      ResultSet rs2 = pstmt2.executeQuery();
      int order_id;
      int table_number;

      while (rs2.next()) {
        order_id = rs2.getInt("order_id");
        table_number = rs2.getInt("table_number");
        double total = 0.0;
%>
<table>
  <tr class="order-header">
    <th colspan="4">订单编号: <%= order_id %> 桌号: <%= table_number %> </th>
  </tr>
  <tr>
    <th>菜品名称</th>
    <th>价格</th>
  </tr>
  <%
    PreparedStatement pstmt3 = conn.prepareStatement("SELECT * FROM order_items WHERE order_id = ?");
    pstmt3.setInt(1, order_id);
    ResultSet rs3 = pstmt3.executeQuery();
    while (rs3.next()) {
      int itemId = rs3.getInt("item_id");
      PreparedStatement pstmt4 = conn.prepareStatement("SELECT * FROM menu_items WHERE item_id = ? AND restaurant_id = ?  ");
      pstmt4.setInt(1, itemId);
      pstmt4.setInt(2, restaurant_id);
      ResultSet rs4 = pstmt4.executeQuery();
      rs4.next();
      String name = rs4.getString("name");
      double price = rs4.getDouble("price");
      total += price;
  %>
  <tr class="order-details">
    <td><%= name %></td>
    <td><%= price %> 元</td>
  </tr>
  <%
    }
  %>
  <tr class="total-price">
    <td colspan="3">总价: <%= total %> 元</td>
  </tr>
</table>
<%
      }
    }

    conn.close();
  } catch (SQLException e) {
    out.println("发生错误: " + e.getMessage());
    e.printStackTrace();
  }
%>

</body>
</html>


