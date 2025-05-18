<%@ Page Language="C#" AutoEventWireup="true" %>

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
                <asp:TextBox ID="Email" runat="server" CssClass="input-box" placeholder="ادخل البريد الكتروني"  TextMode="Email" required></asp:TextBox>
                <asp:TextBox ID="Password" runat="server" CssClass="input-box" placeholder="ادخل كلمة المرور"  TextMode="Password" required ></asp:TextBox>

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
    protected void btnLogin_Click(object sender, EventArgs e)
    {
        


         Email.Text = " ";
        Password.Text = " ";

    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        // مسح الحقول
        Email.Text = " ";
        Password.Text = " ";
    }

</script>
