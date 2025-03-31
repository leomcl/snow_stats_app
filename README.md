# Snow Stats App

A Flutter application for tracking stock portfolio, dividends, and financial analysis data.

## Financial Analysis Feature

The Financial Analysis feature allows users to view detailed financial data for stocks. The feature displays raw financial data from the API, including:

- Revenue
- Net Income
- Assets
- Liabilities
- Shareholder Equity
- Debt
- Cost of Goods Sold
- Operating Income
- Operating Expenses
- Cash Flow
- Dividends Per Share

### How to Use

1. Navigate to the Financial tab in the app
2. Enter a valid stock ticker (e.g., AAPL)
3. Enter a year to retrieve data for
4. Click "Get Data" to fetch and display the financial information

### Filtering Options

The Financial Analysis page includes powerful filtering capabilities:

- **Filing Period Filter**: Filter data by quarterly (Q1, Q2, Q3, Q4) or annual filings
- **Tag Filter**: View data for specific accounting tags/metrics
- All filters can be combined to drill down into specific data points

### Technical Implementation

- Uses a clean architecture approach with BLoC pattern for state management
- Connects to the existing financial data API
- Financial data is fetched using `GetFinancialDataUseCase`
- Additional analysis features can be enabled through the existing `AnalyzeFinancialMetricsUseCase` and `CompareFinancialTrendsUseCase`
