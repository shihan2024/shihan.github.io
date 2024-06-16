<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html >
<html>
<head>
  <title>菜单管理</title>
  <style >
  </style>

</head>
<%int id = Integer.parseInt(request.getParameter("id")); %>
<jsp:include page="topBar.jsp?id=<%= id %>" />
<body>
<h1>菜品管理</h1>

<%
  try {
	  Connection conn = DriverManager.getConnection("jdbc:mysql://172.20.10.2/ordering?", "root", "12345678");

    PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM account WHERE id = ?");
    pstmt.setInt(1, id);
    ResultSet rs = pstmt.executeQuery();
    int restaurant_id =0;
    if (rs.next()) {
      restaurant_id = rs.getInt("restaurant_id");
      PreparedStatement pstmt2 = conn.prepareStatement("SELECT * FROM Menu_Items WHERE restaurant_id = ?");
      pstmt.setInt(1, restaurant_id);
      ResultSet rs2 = pstmt2.executeQuery();

      while (rs2.next()) {
        int item_id = rs2.getInt("item_id");
        String name = rs2.getString("name");
        out.println("<h2>" + name + "</h2>");

        PreparedStatement pstmt3 = conn.prepareStatement("SELECT * FROM order_items WHERE item_id = ?");
        pstmt3.setInt(1, item_id);
        ResultSet rs3 = pstmt3.executeQuery();

        while (rs3.next()) {
          int order_id = rs3.getInt("order_id");

          PreparedStatement pstmt4 = conn.prepareStatement("SELECT * FROM orders WHERE order_id = ?");
          pstmt4.setInt(1, order_id);
          ResultSet rs4 = pstmt4.executeQuery();

          while (rs4.next()) {
            int table_number = rs4.getInt("table_number");
            out.println("<h2>桌号: " + table_number + "</h2>");
          }
        }
      }

      while (rs2.next()) {
        String name = rs2.getString("name");
        String image = rs2.getString("url");
        double price = rs2.getDouble("price");
%>
<div>
  <img src="<%= image %>" alt="<%= name %>">
  <h2><%= name %></h2>
  <p>价格: <%= price %> 元</p><br>
</div>
<%
      }
    }
    conn.close();
  } catch (SQLException e) {
    e.printStackTrace();
  }
%>
</body>
</html>
