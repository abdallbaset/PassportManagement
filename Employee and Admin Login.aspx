<%@ Page Language="C#" AutoEventWireup="true" %>
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
                <asp:TextBox ID="Email" runat="server" CssClass="input-box" placeholder="ادخل البريد الكتروني"  TextMode="Email" required></asp:TextBox>
                <asp:TextBox ID="Password" runat="server" CssClass="input-box" placeholder="ادخل كلمة المرور"  TextMode="Password" required ></asp:TextBox>

                <div class="buttons">
                    <asp:Button ID="btnClear" runat="server" Text="مسح الحقول "  CssClass="clear" OnClick="btnClear_Click"/>
                    <asp:Button ID="btnLogin" runat="server" Text="تسجيل الدخول" CssClass="login" OnClick="btnLogin_Click"/>
                    <br />
                    <br />

                </div>
                <asp:Label ID="lblMessage" runat="server" CssClass="msg-success" Visible="false"></asp:Label>
            </form>
        </div>
    </div>
</body>
</html>

<script runat="server">
        SqlConnection con = new SqlConnection("Server=msi;Database=the_main;Integrated Security=True;");
        protected void btnLogin_Click(object sender, EventArgs e)
        {

            string sql = "select *from users where email =@email and password_hash=@pass";
            SqlCommand cmd = new SqlCommand(sql, con);
            cmd.Parameters.AddWithValue("@email", Email.Text);
            cmd.Parameters.AddWithValue("@pass", Password.Text);
            SqlDataReader read;
            con.Open();
            read = cmd.ExecuteReader();
            if (read.HasRows)
            {
                string user_type = "";
                while (read.Read())
                {
                    Session["user"] = read["User_id"].ToString();
                    user_type = read["role"].ToString();
                }

                con.Close();

                if (user_type == "1")
                {
                    Response.Redirect("Admin main interface.aspx");
                }

                else if (user_type == "2")
                {

                    Response.Redirect("Employee interface.apx");
                }
                else
                {
                    lblMessage.Visible = true;
                    lblMessage.Text = "كلمة المرور او البريد الكتروني خاطئ";

                }
            }
            else
            {
                Email.Text = " ";
                lblMessage.Visible = true;
                lblMessage.Text = "  !!!!!   ";

            }


        }

    

    protected void btnClear_Click(object sender, EventArgs e)
    {
        // مسح الحقول
        Email.Text = " ";
        Password.Text = " ";
    }


</script>
