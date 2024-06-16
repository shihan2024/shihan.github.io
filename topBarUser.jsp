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
  <a href="kitchenMenu.jsp?id=<%= id %>" class="<%= request.getRequestURI().endsWith("kitchenMenu.jsp") ? "active" : "" %>">制作菜品</a>
  <a href="typeManagement.jsp?id=<%= id %>&type=2" class="<%= request.getRequestURI().endsWith("typeManagement.jsp") ? "active" : "" %>">菜品管理</a>
</div>
