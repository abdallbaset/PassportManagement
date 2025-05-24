<%@ Page Title="" Language="C#" MasterPageFile="~/Admin Main Interface.master" AutoEventWireup="true" CodeFile="Report log.aspx.cs" Inherits="Report_log" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">
            protected void Page_Load(object sender, EventArgs e)
            {
                if (!IsPostBack)
                {

                    ddlReportType.Items[0].Attributes.Add("disabled", "true"); // dropDowinlist تعطيل الخيار الأول في 
                }

    
        }
          private List<string> GetHeaderText(string reportType)
            {
                switch (reportType)
                {
                    case "All":
                        return new List<string> { "عدد القبول", "عدد الرفض", "عدد التجديد", "عدد إنشاء جديد", "إجمالي الطلبات" };
                    case "Accepted":
                        return new List<string> { "الرقم الوطني", "الاسم", "المدينة", "المنطقة", "رقم الهاتف" };
                    case "RenewalRejected":
                        return new List<string> { "الرقم الوطني", "الاسم", "المدينة", "المنطقة", "سبب الرفض" };
                    case "NewRejected":
                        return new List<string> { "الرقم الوطني", "الاسم", "المدينة", "المنطقة", "سبب الرفض" };
                    case "Reported":
                        return new List<string> { "الرقم الوطني", "الاسم", "المدينة", "المنطقة", "تفاصيل الإبلاغ" };
                    default:
                        return new List<string> { "التقرير" };
                }
            }
private DataTable GetReport(string reportType, DateTime startDate, DateTime endDate)
{
    DataTable dt = new DataTable();
    SqlConnection conn = null;
    SqlCommand cmd = null;
    SqlDataAdapter adapter = null;

    try
    {
        conn = new SqlConnection("");
        conn.Open();

        string query = "SELECT * FROM اسم الجدول هنا WHERE اسم عمود نوع التقرير  = @ReportType AND اسم عمود التاريخ BETWEEN @StartDate AND @EndDate";
        cmd = new SqlCommand(query, conn);
        cmd.Parameters.AddWithValue("@ReportType", reportType);
        cmd.Parameters.AddWithValue("@StartDate", startDate);
        cmd.Parameters.AddWithValue("@EndDate", endDate);

        adapter = new SqlDataAdapter(cmd);
        adapter.Fill(dt);
    }
    catch (Exception ex)
    {
        Console.WriteLine("Error: " + ex.Message);
    }
    finally
    {
        if (adapter != null) adapter.Dispose();
        if (cmd != null) cmd.Dispose();
        if (conn != null) conn.Close();
    }

    return dt;
}



    protected void btnSearch_Click(object sender, EventArgs e)
{
    string reportType = ddlReportType.SelectedValue;
    DateTime startDate = DateTime.Parse(txtStartDate.Text);
    DateTime endDate = DateTime.Parse(txtEndDate.Text);

    DataTable dt = GetReport(reportType, startDate, endDate);
    List<string> headers = GetHeaderText(reportType);

    // إزالة الأعمدة القديمة وإضافة الجديدة 

    gvReport.Columns.Clear();
//تكرار الحلقة حتى انتهاء عناصر القائمة
   foreach (string header in headers)
{
    gvReport.Columns.Add(new BoundField { DataField = header, HeaderText = header });
}
    //   GridView عرض البيانات في 
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
             width: 100px;
             height: 30px;
             outline: none;
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

<asp:DropDownList ID="ddlReportType" CssClass="ddlReportType" runat="server">
    <asp:ListItem Text="نوع التقرير" Value="" Selected="True" />
    <asp:ListItem Text="تقرير شامل" Value="All" />
    <asp:ListItem Text="تقرير بالقبول" Value="Accepted" />
    <asp:ListItem Text="تقرير رفض تجديد" Value="RenewalRejected" />
    <asp:ListItem Text="تقرير رفض جديد" Value="NewRejected" />
    <asp:ListItem Text="تقرير بالإبلاغ" Value="Reported" />
</asp:DropDownList>

               <asp:GridView ID="gvReport" runat="server" AutoGenerateColumns="False" >
                  </asp:GridView>



         </form>
</asp:Content>

