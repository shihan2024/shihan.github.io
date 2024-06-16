<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>点餐状态</title>
    <style>
        .container {
            display: flex;
            justify-content: space-between;
            padding: 20px;
            flex-wrap: wrap;
            justify-content: flex-start; /* 设置向左对齐 */
        }

        .rectangle {
            width: 300px; /* 宽度 */
            height: 600px; /* 高度 */
            display: flex;
            flex-direction: column;
            margin: 15px;
        }

        .green {
            background-color: #ffb967;
            border: 1px solid black; /* 绿色背景边框线 */
            flex: 1; /* 占四分之一 */
        }

        .white {
            background-color: white;
            border: 2px solid black; /* 白色背景边框线 */
            flex: 3; /* 占四分之三 */
        }
        .checkout {
            margin-top: auto; /* 将按钮推到底部 */
            width: 80%; /* 设置按钮宽度 */
            padding: 10px;
            background-color: #b5b5b5; /* 设置按钮背景颜色 */
            color: #000000; /* 设置字体颜色为黑色 */
            border: 2px solid #000000; /* 添加2px宽度的黑色边框 */
            border-radius: 5px; /* 设置按钮圆角 */
            cursor: pointer;
        }
    </style>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="refresh" content="10">
</head>
<body>
<%int id = Integer.parseInt(request.getParameter("id")); %>
<jsp:include page="topBar.jsp?id=<%= id %>" />
<div class="container">
    <%
        try {
        	Connection conn = DriverManager.getConnection("jdbc:mysql://172.20.10.2/ordering?", "root", "12345678");

            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM account WHERE id = ?");
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            int restaurant_id;
            if (rs.next()) {
                restaurant_id = rs.getInt("restaurant_id");

                PreparedStatement pstmt2 = conn.prepareStatement("SELECT * FROM tables WHERE restaurant_id = ?");
                pstmt2.setInt(1, restaurant_id);
                ResultSet rs2 = pstmt2.executeQuery();
                while (rs2.next()) {
                    int table_number = rs2.getInt("table_number");
    %>
    <div class="rectangle">
        <div class="green">
            <div class="text">
                <h2>餐桌 <%= table_number %> </h2><%
                PreparedStatement pstmt5 = conn.prepareStatement("SELECT * FROM orders WHERE table_number = ? AND restaurant_id = ? AND status = 'yes'");
                pstmt5.setInt(1, table_number);
                pstmt5.setInt(2, restaurant_id);
                ResultSet rs5 = pstmt5.executeQuery();
                if (rs5.isBeforeFirst()) {
                    out.println("<a href='checkout.jsp?tableNumber=" + table_number + "&restaurantId=" + restaurant_id + "&id=" + id + "'>");
                    out.println("<button class='checkout'>结算</button>");
                    out.println("</a>");}
%>

            </div>
        </div>
        <div class="white">
            <div class="text">
                </a>
                <!-- 遍历订单项信息 -->
                <%
                    if (rs5.next()) { // 将光标移动到第一行
                        int orderId = rs5.getInt("order_id");

                        PreparedStatement pstmt3 = conn.prepareStatement("SELECT * FROM Order_items WHERE Order_id = ? AND STATUS IN ('after','before','during')");
                        pstmt3.setInt(1, orderId);
                        ResultSet rs3 = pstmt3.executeQuery();
                        while (rs3.next()) {
                            int itemId = rs3.getInt("item_id");
                            PreparedStatement pstmt4 = conn.prepareStatement("SELECT * FROM `menu_items` WHERE item_id = ? AND restaurant_id = ?  ");
                            pstmt4.setInt(1, itemId);
                            pstmt4.setInt(2, restaurant_id);
                            ResultSet rs4 = pstmt4.executeQuery();
                            rs4.next();
                            String name = rs4.getString("name");
                            double price = rs4.getDouble("price");
                            String status = rs3.getString("status");
                            switch (status) {
                                case "before":
                                    status = "未制作";
                                    break;
                                case "during":
                                    status = "制作中";
                                    break;
                                case "after":
                                    status = "制作完成";
                                    break;
                            }
                %>
                <p><%= name %>
                    价格: <%= price %> 元
                    状态: <%= status %>
                        <% if (status.equals("未制作")) { %>
                    <a href="cancel.jsp?itemId=<%=itemId%>&orderId=<%=orderId%>&tableNumber=<%=table_number%>&restaurantId=<%=restaurant_id%>&id=<%=id%>"><button>退菜</button></a>
                        <% } %>
                <%
                        }
                    }
                %></div>
        </div>
    </div>
    <%
                }
            } else {
                throw new SQLException("无法获取生成的订单ID");
            }

            conn.close();
        } catch (SQLException e) {
            out.println("发生错误: " + e.getMessage());
            e.printStackTrace();
        }
    %>
</div>
</body>
</html>