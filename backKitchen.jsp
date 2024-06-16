<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html >
<html>
<head>
    <title>后厨界面</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
        }

        .button-container {
            display: flex;

            justify-content: space-around;
            margin-top: 30px;
        }

        .button {
            padding: 15px 30px;
            font-size: 18px;
            text-transform: uppercase;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .button:hover {
            background-color: #4caf50;
            color: #fff;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>后厨界面</h1>
    <div class="button-container">
        <form action="typeManagement.jsp">
            <button type="submit" class="button">管理菜品</button>
        </form>
        <form action="kitchenMenu.jsp">
            <button type="submit" class="button">查看订单</button>
        </form>
    </div>
</div>
</body>
</html>