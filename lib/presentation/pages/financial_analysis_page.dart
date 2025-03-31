import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/financial/financial_bloc.dart';
import '../blocs/financial/financial_event.dart';
import '../blocs/financial/financial_state.dart';

class FinancialAnalysisPage extends StatefulWidget {
  const FinancialAnalysisPage({super.key});

  @override
  State<FinancialAnalysisPage> createState() => _FinancialAnalysisPageState();
}

class _FinancialAnalysisPageState extends State<FinancialAnalysisPage> {
  final TextEditingController _tickerController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final int currentYear = DateTime.now().year;

  // Filter options
  String _selectedPeriod = 'All';
  String _selectedTag = 'All';
  List<String> _periodOptions = ['All', 'Annual', 'Q1', 'Q2', 'Q3', 'Q4'];
  List<String> _availableTags = ['All'];

  @override
  void initState() {
    super.initState();
    _yearController.text = currentYear.toString();
  }

  @override
  void dispose() {
    _tickerController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _fetchFinancialData() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _selectedPeriod = 'All';
      _selectedTag = 'All';
    });

    context.read<FinancialBloc>().add(
          GetFinancialData(
            _tickerController.text.toUpperCase(),
            int.parse(_yearController.text),
          ),
        );
  }

  // Extract unique tags from financial data
  void _extractAvailableTags(FinancialDataLoaded state) {
    Set<String> tags = {'All'};

    void addTagsFromMetrics(List metrics) {
      for (var metric in metrics) {
        tags.add(metric.tag);
      }
    }

    addTagsFromMetrics(state.data.data.revenue);
    addTagsFromMetrics(state.data.data.netIncome);
    addTagsFromMetrics(state.data.data.assets);
    addTagsFromMetrics(state.data.data.liabilities);
    addTagsFromMetrics(state.data.data.shareholderEquity);
    addTagsFromMetrics(state.data.data.debt);
    addTagsFromMetrics(state.data.data.costOfGoodsSold);
    addTagsFromMetrics(state.data.data.operatingIncome);
    addTagsFromMetrics(state.data.data.operatingExpenses);
    addTagsFromMetrics(state.data.data.cashFlow);
    addTagsFromMetrics(state.data.data.dividendsPerShare);

    _availableTags = tags.toList()..sort();
  }

  // Filter metrics based on selected period and tag
  List _filterMetrics(List metrics) {
    return metrics.where((metric) {
      bool periodMatch = _selectedPeriod == 'All' ||
          (_selectedPeriod == 'Annual' && metric.fp.startsWith('FY')) ||
          metric.fp == _selectedPeriod;

      bool tagMatch = _selectedTag == 'All' || metric.tag == _selectedTag;

      return periodMatch && tagMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Data'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _tickerController,
                      decoration: const InputDecoration(
                        labelText: 'Stock Symbol',
                        hintText: 'e.g., AAPL',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a stock symbol';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _yearController,
                      decoration: const InputDecoration(
                        labelText: 'Year',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final year = int.tryParse(value);
                        if (year == null || year < 2000 || year > currentYear) {
                          return 'Invalid year';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _fetchFinancialData,
                    child: const Text('Get Data'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<FinancialBloc, FinancialState>(
              builder: (context, state) {
                if (state is FinancialLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FinancialError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  );
                } else if (state is FinancialDataLoaded) {
                  // Extract available tags when data is loaded
                  if (_availableTags.length <= 1) {
                    _extractAvailableTags(state);
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Filing Period:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      DropdownButton<String>(
                                        isExpanded: true,
                                        value: _selectedPeriod,
                                        items: _periodOptions
                                            .map((period) => DropdownMenuItem(
                                                  value: period,
                                                  child: Text(period),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedPeriod = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Tag:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      DropdownButton<String>(
                                        isExpanded: true,
                                        value: _selectedTag,
                                        items: _availableTags
                                            .map((tag) => DropdownMenuItem(
                                                  value: tag,
                                                  child: Text(tag,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedTag = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Financial Data for ${state.data.ticker} (${state.year})',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 24),
                              _buildDataSection('Revenue',
                                  _filterMetrics(state.data.data.revenue)),
                              _buildDataSection('Net Income',
                                  _filterMetrics(state.data.data.netIncome)),
                              _buildDataSection('Assets',
                                  _filterMetrics(state.data.data.assets)),
                              _buildDataSection('Liabilities',
                                  _filterMetrics(state.data.data.liabilities)),
                              _buildDataSection(
                                  'Shareholder Equity',
                                  _filterMetrics(
                                      state.data.data.shareholderEquity)),
                              _buildDataSection(
                                  'Debt', _filterMetrics(state.data.data.debt)),
                              _buildDataSection(
                                  'Cost of Goods Sold',
                                  _filterMetrics(
                                      state.data.data.costOfGoodsSold)),
                              _buildDataSection(
                                  'Operating Income',
                                  _filterMetrics(
                                      state.data.data.operatingIncome)),
                              _buildDataSection(
                                  'Operating Expenses',
                                  _filterMetrics(
                                      state.data.data.operatingExpenses)),
                              _buildDataSection('Cash Flow',
                                  _filterMetrics(state.data.data.cashFlow)),
                              _buildDataSection(
                                  'Dividends Per Share',
                                  _filterMetrics(
                                      state.data.data.dividendsPerShare)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.assessment,
                            size: 64, color: Colors.blue),
                        const SizedBox(height: 16),
                        Text(
                          'Enter a stock symbol and year to view financial data',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSection(String title, List metrics) {
    if (metrics.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),
            ...metrics
                .map((metric) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Value: ${metric.value}'),
                          Text('Unit: ${metric.unit}'),
                          if (metric.start != null)
                            Text('Period: ${metric.start} to ${metric.end}')
                          else
                            Text('Date: ${metric.end}'),
                          Text('Form: ${metric.form}'),
                          Text('Filing Period: ${metric.fp}'),
                          Text('Tag: ${metric.tag}'),
                          Text('Report Type: ${metric.reportType}'),
                          const Divider(),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
