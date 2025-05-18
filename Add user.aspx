<%@ Page Title="" Language="C#" MasterPageFile="~/Admin Main Interface.master"   %>

<script runat="server">

    protected void btnAddUser_Click(object sender, EventArgs e)
    {

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
            width: 70%;
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
            width: 77%;
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

    <div class="form-container">
        <h2>إضافة مستخدم جديد</h2>

        <asp:TextBox ID="txtEmail" runat="server" CssClass="input-box" placeholder="  ادخل البريد الإلكتروني" required TextMode="Email" ></asp:TextBox>
        <asp:TextBox ID="txtPassword" runat="server" CssClass="input-box" placeholder=" ادخل كلمة المرور  " TextMode="Password" required ></asp:TextBox>

        <asp:Button ID="btnAddUser" runat="server" Text="إضافة مستخدم" CssClass="btn-add" OnClick="btnAddUser_Click" />

        <asp:Label ID="lblMessage" runat="server" CssClass="msg-success" Visible="false"></asp:Label>
    </div>
</asp:Content>
