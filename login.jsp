<%@ page import="java.sql.*, java.security.MessageDigest" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>登录页面</title>
</head>
<body>
<h1>登录</h1>
<form method="post" action="login.jsp">
    <label>账号:</label>
    <input type="text" name="user_id"><br>
    <label>密码:</label>
    <input type="password" name="password"><br>


    <label>选择登录类型:</label><br>
    <input type="radio" name="loginType" value="front" checked>前台登录
    <input type="radio" name="loginType" value="back">后台登录<br>

    <input type="submit" value="登录">
</form>

<%
    Connection con = null;
    PreparedStatement ps = null;

    try {
        String user_id = request.getParameter("user_id");
        String password = request.getParameter("password");
        String loginType = request.getParameter("loginType");

        if (user_id != null && password != null && loginType != null) {
            Class.forName("com.mysql.cj.jdbc.Driver");
             con = DriverManager.getConnection("jdbc:mysql://172.20.10.2/ordering?", "root", "12345678");

            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(password.getBytes());
            byte[] digest = md.digest();
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) {
                sb.append(String.format("%02x", b & 0xff));
            }
            String hashedPassword = sb.toString();
            ps = con.prepareStatement("SELECT * FROM account WHERE user_id = ? AND password = ? AND type = ?");
            ps.setString(1, user_id);
            ps.setString(2, hashedPassword);
            ps.setString(3, loginType);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("id");
                if (loginType.equals("front")) {
                    response.sendRedirect("topBar.jsp?id=" + id);
                } else {
                    response.sendRedirect("topBarKitchen.jsp?id=" + id);
                }
            } else {
                out.println("<h1 class=\"error-message\">账号或密码错误</h1>");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h1 class=\"error-message\">登录失败</h1>");
    } finally {
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>
</body>
</html>