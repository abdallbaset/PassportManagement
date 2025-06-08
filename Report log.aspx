<%@ Page Title="" Language="C#" MasterPageFile="~/Admin Main Interface.master" AutoEventWireup="true" CodeFile="Report log.aspx.cs" Inherits="Report_log" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlReportType.Items[0].Attributes.Add("disabled", "true"); // تعطيل الخيار الأول في القائمة المنسدلة
        }
    }

    private List<string> GetHeaderText(string reportType)
    {
        switch (reportType)
        {
            case "All":
                return new List<string> { "TotalAccepted" , "TotalRenewalRejected", "TotalNewRejected", "TotalRequests" };
            case "Accepted":
                return new List<string> { "national_id", "name", "city", "region", "phone" };
            case "RenewalRejected":
                return new List<string> { "national_id", "name", "city", "region", "rejection_reason" };
            case "NewRejected":
                return new List<string> { "national_id", "name", "city", "region", "rejection_reason" };
            case "Reported":
                return new List<string> { "national_id", "name", "city", "region", "report_details" };
            default:
                return new List<string> { "report" };
        }
    }

    private DataTable GetReport(string reportType, DateTime startDate, DateTime endDate)
    {
        DataTable dt = new DataTable();
        string connectionString = "Server=msi;Database=the_main;Integrated Security=True";

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            try
            {
                conn.Open();
                 string query = "SELECT r.national_id, r.city, r.region, r.phone, c.Full_name FROM report_details r INNER JOIN citizens c ON r.national_id = c.national_id WHERE date BETWEEN @StartDate AND @EndDate  AND r.status = @ReportType;";
                
                if (reportType == "Accepted")
                {

                     query = "SELECT r.phone as 'رقم الهاتف',  r.region as 'المنطقة',r.city as 'المدينة' , r.national_id as 'الرقم الوطني' ,  c.Full_name as 'الاسم' FROM report_details r INNER JOIN citizens c ON r.national_id = c.national_id  WHERE date BETWEEN @StartDate AND @EndDate  AND r.status = @ReportType;";
                }
                else if (reportType == "RenewalRejected" || reportType == "NewRejected")
                {
                     query = "SELECT  r.rejection_reason as 'سبب الرفض',   r.region as 'المنطقة',r.city as 'المدينة' , r.national_id as 'الرقم الوطني' ,  c.Full_name as 'الاسم' FROM report_details r INNER JOIN citizens c ON r.national_id = c.national_id WHERE date BETWEEN @StartDate AND @EndDate  AND r.status = @ReportType;";
                }
                else if (reportType == "Reported")
                {
                    query = "SELECT  r.report_details as 'نوع البلاغ',  r.region as 'المنطقة',r.city as 'المدينة' , r.national_id as 'الرقم الوطني' ,  c.Full_name as 'الاسم' FROM report_details r INNER JOIN citizens c ON r.national_id = c.national_id WHERE date BETWEEN @StartDate AND @EndDate  AND r.status = @ReportType;";
                }

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@ReportType", reportType);
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);

                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(dt);

                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: " + ex.Message);
            }
        }

        return dt;
    }

    private DataTable GetComprehensiveReport(DateTime startDate, DateTime endDate)
    {
        DataTable dt = new DataTable();
        string connectionString = "Server=msi;Database=the_main;Integrated Security=True";

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            try
            {
                conn.Open();

                string query = @"SELECT  
                                COUNT(*) AS 'اجمالي الطلبات',
                                
                                COUNT(CASE WHEN status = 'RenewalRejected' THEN 1 END) AS 'عدد رفض تجديد',
                                COUNT(CASE WHEN status = 'NewRejected' THEN 1 END) AS 'عدد رفض  جديد',
                               COUNT(CASE WHEN status = 'Accepted' THEN 1 END) AS 'عدد القبول'
                            FROM report_details
                            WHERE date BETWEEN @StartDate AND @EndDate";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);

                    using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                    {
                        adapter.Fill(dt);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: " + ex.Message);
            }
        }

        return dt;
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string reportType = ddlReportType.SelectedValue;
        DateTime startDate = DateTime.Parse(txtStartDate.Text);
        DateTime endDate = DateTime.Parse(txtEndDate.Text);

        DataTable dt;
        List<string> headers;

        if (reportType == "All")
        {
            dt = GetComprehensiveReport(startDate, endDate);
            headers = GetHeaderText(reportType);
        }

        else
        {
            dt = GetReport(reportType, startDate, endDate);

            headers = GetHeaderText(reportType);


        }


        // إعداد `GridView`
        gvReport.Columns.Clear();


        gvReport.DataSource = dt;
        gvReport.DataBind();
    }


</script>
    

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
     <style>
      
        form{
            margin-top: 100px;
           max-width:70%;
           margin:100px auto;
           font-family:Tajawal;
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

           .bttnSearch {
         font-family:Tajawal;
         font-weight:700;
         float:right;
         margin-bottom:20px;
         width:70px;
         height:35px;
         border-radius:5px;
         background-color:#cca56e;
         color:#ffffff;
         border:none;
                       }
          .EndDate,.StartDate{
          font-family:Tajawal;
          font-weight:900;
          height:30px;
          float:right;
          width:230px;
          border-radius:5px;
          outline:none;
          border:none;
          margin-right:-22px;
          text-align:right;
        
          }
          .bttnSearch:hover {
    background-color: #b68e54;
                     }
            
         .ddlReportType {
             font-family: Tajawal;
             font-weight: 900;
             float: right;
             margin-right: 20px;
             width: 150px;
             height: 30px;
             outline: none;
         }
         .Erorrmasseg{
               font-family: Tajawal;
               color: red;
               float: right;
               margin-right: 30px;
         }
                
         .StrtDate, .EdDate {
    font-family: Tajawal;
    font-weight: 900;
    height: 30px;
    float: right;
    width: 50px; 
    text-align: right;
    display: inline-block; 
    margin-right: 50px;
}



          
 
    </style>
    <form id="form1" runat="server">
<asp:Button ID="btnSearch" runat="server" CssClass="bttnSearch" Text="بحث" OnClick="btnSearch_Click" />
  <asp:Label ID="Label1" runat="server" CssClass="StrtDate"  Text=":من"></asp:Label>
<asp:TextBox ID="txtStartDate" runat="server" CssClass="StartDate"  TextMode="Date"></asp:TextBox>
  <asp:Label ID="Label2" runat="server" CssClass="EdDate" Text=":إلى"></asp:Label>
<asp:TextBox ID="txtEndDate" runat="server" CssClass="EndDate"  TextMode="Date"></asp:TextBox>

<asp:DropDownList ID="ddlReportType" CssClass="ddlReportType" runat="server" OnSelectedIndexChanged="ddlReportType_SelectedIndexChanged">
    <asp:ListItem Text="نوع التقرير" Value="" Selected="True" />
    <asp:ListItem Text="تقرير شامل" Value="All" />
    <asp:ListItem Text="تقرير بالقبول" Value="Accepted" />
    <asp:ListItem Text="تقرير رفض تجديد" Value="RenewalRejected" />
    <asp:ListItem Text="تقرير رفض جديد" Value="NewRejected" />
    <asp:ListItem Text="تقرير بالإبلاغ" Value="Reported" />
</asp:DropDownList>
        <asp:Label ID="Erorrmasseg" runat="server" Text="" CssClass="Erorrmasseg"></asp:Label>
               <asp:GridView ID="gvReport" runat="server" AutoGenerateColumns="true" >
                  </asp:GridView>



         </form>
</asp:Content>

