<%@ Page Title="" Language="C#" MasterPageFile="~/Admin Main Interface.master" AutoEventWireup="true" CodeFile="Admin requests.aspx.cs" Inherits="Admin_requests" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">

    SqlConnection con = new SqlConnection("Server=msi;Database=the_main;Integrated Security=True");

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindGridView();
        }
    }

    protected void BindGridView()
    {
        try
        {
            string query = "SELECT p.Request_id, p.Request_type, p.Request_date, a.National_id FROM passport_requests p INNER JOIN appointments a ON p.Appointment_id = a.Appointment_id WHERE p.Status =0;";

            con.Open();
            SqlDataAdapter da = new SqlDataAdapter(query, con);
            DataTable data = new DataTable();
            da.Fill(data);

            if (data.Rows.Count > 0)
            {
                GridView1.DataSource = data;
                GridView1.DataBind();
            }
            else
            {
                Labe_maseg.Text = "لا توجد بيانات لعرضها.";
            }
        }
        catch (Exception ex)
        {
            Labe_maseg.Text = "حدث خطأ أثناء جلب البيانات: " + ex.Message;
        }
        finally
        {
            con.Close();
        }
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int rowIndex = Convert.ToInt32(e.CommandArgument);
        string requestId = GridView1.DataKeys[rowIndex].Value.ToString();

        if (e.CommandName == "acceptance")
        {
            AcceptRequest(requestId);
            Labe_maseg.Text = "تم قبول الطلب بنجاح.";
        }
        else if (e.CommandName == "Rejection")
        {
            RejectRequest(requestId);
            Labe_maseg.Text = "تم رفض الطلب.";
        }
    }

    protected void AcceptRequest(string requestId)
    {
        using (SqlConnection con = new SqlConnection("Server=msi;Database=the_main;Integrated Security=True"))
        {
            con.Open();
            string query = "UPDATE passport_requests SET Status = '1' WHERE Request_id = @RequestId";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@RequestId", requestId);
                cmd.ExecuteNonQuery();
            }
            DateTime now = DateTime.Now;
            string Userid = Session["User"].ToString();
            string sql = "insert into local_history(user_id,action_type,creat_at) values (@user_id,@action_type,@creat_at)";
            SqlCommand cmda = new SqlCommand(sql, con);
            cmda.Parameters.AddWithValue("@user_id", int.Parse(Userid));
            cmda.Parameters.AddWithValue("@action_type", "قبول");
            cmda.Parameters.AddWithValue("@creat_at", now);
            cmda.ExecuteNonQuery();
            string sql1 = "INSERT INTO report_details (status, Appointment_id) SELECT 'قبول', Appointment_id FROM passport_requests WHERE Request_id = @RequestId;";
            SqlCommand cmd1 = new SqlCommand(sql1, con);
            cmd1.ExecuteNonQuery();
            con.Close();

        }
    }

    protected void RejectRequest(string requestId)
    {
        using (SqlConnection con = new SqlConnection("Server=msi;Database=the_main;Integrated Security=True"))
        {
            con.Open();
            string query = "UPDATE passport_requests SET Status = '1' WHERE Request_id = @RequestId";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@RequestId", requestId);
                cmd.ExecuteNonQuery();
            }
            DateTime now = DateTime.Now;
            string Userid = Session["User"].ToString();
            string sql = "insert into local_history(user_id,action_type,creat_at) values (@user_id,@action_type,@creat_at)";
            SqlCommand cmda = new SqlCommand(sql, con);
            cmda.Parameters.AddWithValue("@user_id", int.Parse(Userid));
            cmda.Parameters.AddWithValue("@action_type", "رفض");
            cmda.Parameters.AddWithValue("@creat_at", now);
             string sql2 = "INSERT INTO report_details (status, Appointment_id) SELECT 'رفض', Appointment_id FROM passport_requests WHERE Request_id = @RequestId;";
            SqlCommand cmd1 = new SqlCommand(sql2, con);
            
            con.Open();
            cmd1.ExecuteNonQuery();

            cmda.ExecuteNonQuery();
            con.Close();

        }
    }

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <style>
        form {
            margin-top: 100px;
            max-width: 70%;
            margin: 100px auto;
            font-family: Tajawal;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        table th, table td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: center;
        }

        table th {
            background-color: #152d52;
            color: white;
        }

        .maseeg {
            display: block;
            margin-top: 10px;
            font-weight: bold;
            color: #28a745;
            text-align: center;
        }

        .acceptance-button {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }

        .Rejection-button {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>

    <form id="form1" runat="server">
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="table" GridLines="None" DataKeyNames="Request_id" AllowPaging="True"
            PageSize="6" OnRowCommand="GridView1_RowCommand">
            <Columns>
                <asp:TemplateField HeaderText="الإجراء">
                    <ItemTemplate>
                        <asp:Button ID="btnRejection" runat="server" Text="رفض" CommandName="Rejection" CommandArgument='<%# Container.DataItemIndex %>' CssClass="Rejection-button" />
                        <asp:Button ID="btnacceptance" runat="server" Text="قبول" CommandName="acceptance" CommandArgument='<%# Container.DataItemIndex %>' CssClass="acceptance-button" />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="Request_type" HeaderText="نوع الطلب" />
                <asp:BoundField DataField="Request_date" HeaderText="تاريخ تقديم الطلب" />
                <asp:BoundField DataField="National_id" HeaderText="رقم الوطني لمقدم الطلب" />
                <asp:BoundField DataField="Request_id" HeaderText="رقم الطلب" />
            </Columns>
        </asp:GridView>

        <asp:Label ID="Labe_maseg" runat="server" CssClass="maseeg"></asp:Label>
    </form>
</asp:Content>