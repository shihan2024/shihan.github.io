<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<%
    // 获取订单ID
    String orderId = request.getParameter("order_id");

// 更新订单状态为 "yes"
    try {
// 连接数据库
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://172.20.10.2/ordering?", "root", "12345678");

// 执行更新状态的 SQL 语句
        PreparedStatement pstmt = conn.prepareStatement("UPDATE Orders SET status = 'yes' WHERE order_id = ?");
        pstmt.setString(1, orderId);
        pstmt.executeUpdate();

// 关闭连接和语句
        pstmt.close();
        conn.close();

// 显示成功消息
        out.println("<h1>订单确认成功！</h1>");
        out.println("<p>订单 #" + orderId + " 的状态已更新为 'yes'。</p>");

// JavaScript重定向到orders.jsp页面
        out.println("<script type='text/javascript'>");
        out.println("alert('修改成功！');");
        out.println("window.location.href = 'orders.jsp';");
        out.println("</script>");

    } catch (Exception e) {
// 显示错误消息
        out.println("<h1>错误！</h1>");
        out.println("<p>订单确认时发生错误：" + e.getMessage() + "</p>");
    }
%>