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
                 string query = "";
                
                if (reportType == "Accepted")
                {

                     query = "SELECT a.phone AS 'رقم الهاتف', a.district AS 'المنطقة', a.city AS 'المدينة', a.national_id AS 'الرقم الوطني', c.Full_name AS 'الاسم' FROM appointments a INNER JOIN citizens c ON a.national_id = c.national_id WHERE a.Appointment_date BETWEEN @StartDate AND @EndDate AND a.Request_type = @ReportType";
                }
                else if (reportType == "RenewalRejected" || reportType == "NewRejected")
                {
                     query = "SELECT  r.rejection_reason as 'سبب الرفض',   a.district AS 'المنطقة', a.city AS 'المدينة', a.national_id AS 'الرقم الوطني', c.Full_name AS 'الاسم' FROM appointments a INNER JOIN citizens c ON a.national_id = c.national_id INNER JOIN report_details r on a.Appointment_id= r.Appointment_id  WHERE a.Appointment_date BETWEEN @StartDate AND @EndDate AND a.Request_type = @ReportType";
                }
                else if (reportType == "Reported")
                {
                    query = "SELECT  r.report_details as 'نوع البلاغ',   a.district AS 'المنطقة', a.city AS 'المدينة', a.national_id AS 'الرقم الوطني', c.Full_name AS 'الاسم' FROM appointments a INNER JOIN citizens c ON a.national_id = c.national_id INNER JOIN report_details r on a.Appointment_id= r.Appointment_id  WHERE a.Appointment_date BETWEEN @StartDate AND @EndDate AND a.Request_type = @ReportType";
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
    COUNT(CASE WHEN Request_type = 'RenewalRejected' THEN 1 END) AS 'عدد تجديد جواز',
    COUNT(CASE WHEN Request_type = 'NewRejected' THEN 1 END) AS 'عدد إنشاء جواز جديد',
    COUNT(CASE WHEN Request_type = 'Reported' THEN 1 END) AS 'عدد الإبلاغات',
    COUNT(CASE WHEN status = 'قبول' THEN 1 END) AS 'إجمالي الطلبات المقبولة',
    COUNT(CASE WHEN status = 'رفض' THEN 1 END) AS 'إجمالي الطلبات المرفوضة'
FROM appointments
LEFT JOIN report_details ON appointments.appointment_id = report_details.appointment_id
WHERE appointment_date BETWEEN @StartDate AND @EndDate";



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
               <asp:GridView ID="gvReport" runat="server" AutoGenerateColumns="true" OnSelectedIndexChanged="gvReport_SelectedIndexChanged" >
                  </asp:GridView>



         </form>
</asp:Content>

