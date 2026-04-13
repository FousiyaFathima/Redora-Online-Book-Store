<%@ page import="java.util.*" %>

<%
ArrayList<String> books = (ArrayList<String>)session.getAttribute("books");
ArrayList<Integer> prices = (ArrayList<Integer>)session.getAttribute("prices");
ArrayList<String> images = (ArrayList<String>)session.getAttribute("images");
ArrayList<Integer> qty = (ArrayList<Integer>)session.getAttribute("qty");

int index = -1;

try{
    index = Integer.parseInt(request.getParameter("index"));
}catch(Exception e){
    response.sendRedirect("cart.jsp");
    return;
}

String action = request.getParameter("action");

if(action.equals("inc")){
    qty.set(index, qty.get(index) + 1);
}else{
    qty.set(index, qty.get(index) - 1);

    if(qty.get(index) <= 0){
        books.remove(index);
        prices.remove(index);
        images.remove(index);
        qty.remove(index);
    }
}

response.sendRedirect("cart.jsp");
%>