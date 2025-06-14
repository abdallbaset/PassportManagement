﻿<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html>
<html lang="ar">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>تسجيل الدخول</title>
    <link rel="stylesheet" href="Citizent.css">
</head>
<body>
    <div class="container">
        <img src="image/trans_bg.png" alt="شعار النظام" class="logo">

        <div class="form-container">
            <h2>تسجيل الدخول</h2>
            <p>الدخول لحسابك</p>
            <form id="form1" runat="server">
                <asp:TextBox ID="txtNationalID" runat="server" CssClass="input-box" placeholder="ادخل رقم الوطني" required ></asp:TextBox>
                <asp:TextBox ID="txtFamilyBook" runat="server" CssClass="input-box" placeholder="ادخل رقم كتيب العائلة" required></asp:TextBox>

                <div class="buttons">
                    <asp:Button ID="btnClear" runat="server" Text="مسح الحقول "  CssClass="clear" OnClick="btnClear_Click"/>
                    <asp:Button ID="btnLogin" runat="server" Text="تسجيل الدخول" CssClass="login" OnClick="btnLogin_Click"/>
                </div>
            </form>
        </div>
    </div>
</body>
</html>

<script runat="server">
    SqlConnection con = new SqlConnection("Server=msi;Database=the_main;Integrated Security=True;");
    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string sql = "select *from citizens where National_id =@National_id and Family_book_number=@Family_book_number";
        SqlCommand cmd = new SqlCommand(sql, con);
        cmd.Parameters.AddWithValue("@National_id", txtNationalID.Text);
        cmd.Parameters.AddWithValue("@Family_book_number", txtFamilyBook.Text);
        SqlDataReader read;
        con.Open();
        read = cmd.ExecuteReader();
        if (read.HasRows)
        {
            Response.Redirect("citizens interface");

        }



    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        // مسح الحقول
        txtNationalID.Text = "";
        txtFamilyBook.Text = "";
    }
</script>

