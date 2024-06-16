<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    .topbar {
        background-color: #333;
        overflow: hidden;
    }

    .topbar a {
        float: left;
        color: #f2f2f2;
        text-align: center;
        padding: 14px 16px;
        text-decoration: none;
        font-size: 17px;
    }

    .topbar a:hover {
        background-color: #ddd;
        color: black;
    }

    .topbar a.active {
        background-color: #007bff;
        color: white;
    }
</style>
<%int id = Integer.parseInt(request.getParameter("id")); %>
<div class="topbar">
    <a href="frontDesk.jsp?id=<%= id %>" class="<%= request.getRequestURI().endsWith("frontDesk.jsp") ? "active" : "" %>">点餐状态</a>
    <a href="orderView.jsp?id=<%= id %>" class="<%= request.getRequestURI().endsWith("orderView.jsp") ? "active" : "" %>">订单查看</a>
    <a href="typeManagement.jsp?id=<%= id %>&type=1" class="<%= request.getRequestURI().endsWith("menuManagement.jsp") ? "active" : "" %>">菜品管理</a>
    <a href="turnover.jsp?id=<%= id %>" class="<%= request.getRequestURI().endsWith("turnover.jsp") ? "active" : "" %>">营业额统计</a>
</div>
