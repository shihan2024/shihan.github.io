<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html >
<html>
<head>
    <title>菜单管理</title>
    <style>
        table {
            font-family: Arial, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        th, td {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }

        th {
            background-color: #f2f2f2;
        }

        img {
            max-width: 100px;
            height: auto;
        }
    </style>
</head>

<%int id = Integer.parseInt(request.getParameter("id"));
    int type = Integer.parseInt(request.getParameter("type"));
    if(type == 1) { %>
<jsp:include page="topBar.jsp?id=<%= id %>" />
<%} else { %>
<jsp:include page="topBarKitchen.jsp?id=<%= id %>" />
<%} %>


<body>
<h1>菜品管理</h1>

<%
    try {
    	 Connection conn = DriverManager.getConnection("jdbc:mysql://172.20.10.2/ordering?", "root", "12345678");

        PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM account WHERE id = ?");
        pstmt.setInt(1, id);
        ResultSet rs = pstmt.executeQuery();
        int restaurant_id = 0;
        if (rs.next()) {
            restaurant_id = rs.getInt("restaurant_id");
            pstmt.close(); // Close the first PreparedStatement

            PreparedStatement pstmt2 = conn.prepareStatement("SELECT * FROM Menu_Items WHERE restaurant_id = ?");
            pstmt2.setInt(1, restaurant_id);
            ResultSet rs2 = pstmt2.executeQuery();
%>
<table>
    <tr>
        <th>Name</th>
        <th>Image</th>
        <th>Price (元)</th>
        <th>状态</th>
        <th>Action</th>
    </tr>
    <%
        while (rs2.next()) {
            int item_id = rs2.getInt("item_id");
            String name = rs2.getString("name");
            String image = rs2.getString("url");
            String status = rs2.getString("status");
            double price = rs2.getDouble("price");
    %>
    <tr>
        <td><%= name %></td>
        <td><img src="<%= image %>" alt="<%= name %>"></td>
        <td><%= price %></td>
        <td><%= status %></td>
        <%if(status.equals("Available")){%>
        <td><a href="action.jsp?item_id=<%= item_id %>&id=<%= id %>&type=<%= type %>"><button>下架</button></a></td>
        <%}else{%>
        <td><a href="action.jsp?item_id=<%= item_id %>&id=<%= id %>&type=<%= type %>"><button>上架</button></a></td>
        <%}%>
    </tr>
    <%
        }
    %>
</table>
<%
            pstmt2.close(); // Close the second PreparedStatement
        }
        conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
</body>
</html>