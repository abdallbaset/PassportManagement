<%@ Page Title="" Language="C#" MasterPageFile="~/Employee interface.master" AutoEventWireup="true" CodeFile="Modify employee data.aspx.cs" Inherits="Modify_employee_data" %>
 <%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
  protected void btnAddUser_Click(object sender, EventArgs e)
{
    string connectionString = "Server=msi;Database=the_main;Integrated Security=True";
    
    using (SqlConnection connection = new SqlConnection(connectionString))
    {
        string query = "UPDATE users SET email = @Email, password_hash = @Password WHERE User_id = @User_id";
        SqlCommand command = new SqlCommand(query, connection);

        command.Parameters.AddWithValue("@Email", txtEmail.Text);
        command.Parameters.AddWithValue("@Password", txtPassword.Text);
        command.Parameters.AddWithValue("@User_id", Session["user"].ToString());

        connection.Open();
        int rowsAffected = command.ExecuteNonQuery();
        connection.Close();

        if (rowsAffected > 0)
        {
            lblMessage.Text = "تم تحديث البيانات بنجاح!";
            lblMessage.Visible = true;
        }
        else
        {
            lblMessage.Text = "لم يتم العثور على المستخدم أو حدث خطأ أثناء التحديث.";
            lblMessage.Visible = true;
        }
    }
}
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

        <style>
     

     .form-container {
    width: 80%; 
    max-width: 400px; 
    height:300px;
    margin: 50px auto; 
    padding: 20px; 
    background-color: #fff; 
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1); 
    border-radius: 8px; 
    text-align: center; 
}


        h2 {
            color: #333;
        }

        .input-box {
            font-weight:900;
            width: 85%;
            padding: 12px;
            margin-top: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 6px;
            background-color: #f5f5f5;
            font-family: "Tajawal", Arial, sans-serif;
            outline: none;
            text-align: right;
        }

        .input-box:focus {
            border: #152d52 solid 2px;
        }

        .btn-add {
             font-weight:700;
            width: 91%;
            padding: 12px;
            font-size: 16px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            background-color: #152d52;
            color: white;
            font-family: "Tajawal", Arial, sans-serif;
            margin-top: 15px;
        }

        .btn-add:hover {
            background-color: #252e3e;
        }

        .msg-success {
            display:block;
            color: green;
            font-weight: bold;
            margin-top: 10px;
        }
    </style>

    <form runat="server" class="form-container" >

        <h2>تعديل البيانات</h2>

        <asp:TextBox ID="txtEmail" runat="server" CssClass="input-box" placeholder="   ادخل البريد الإلكتروني الجديد" required TextMode="Email" ></asp:TextBox>
        <asp:TextBox ID="txtPassword" runat="server" CssClass="input-box" placeholder=" ادخل كلمة المرور الجديد  " TextMode="Password" required ></asp:TextBox>

        <asp:Button ID="btnAddUser" runat="server" Text="تحفظ" CssClass="btn-add" OnClick="btnAddUser_Click" />

        <asp:Label ID="lblMessage" runat="server" CssClass="msg-success" Visible="false"></asp:Label>
    </form>
</asp:Content>

