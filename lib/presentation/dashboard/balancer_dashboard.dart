import 'package:chemical_reaction_balancer/imports.dart';

class BalancerDashboard extends StatefulWidget {
  const BalancerDashboard({super.key});

  @override
  State<BalancerDashboard> createState() => _BalancerDashboardState();
}

class _BalancerDashboardState extends State<BalancerDashboard>
    with Strings, AppColors {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final btnHeight = 56.0;
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => DashboardViewModel(),
      builder: (context, model, _) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              title: Text(
                appName,
                style: TextStyle(
                  color: textOnPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: model.formKey,
                        child: TextFormField(
                          controller: model.equationController,
                          decoration: InputDecoration(
                            hintText: sampleEquation,
                            labelText: 'Enter a chemical equation to balance',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            border: border,
                            enabledBorder: border,
                            focusedBorder: border,
                          ),
                          onChanged: (value) => model.callFormValidator(),
                          validator: (value) => model.validateEquation(value),
                        ),
                      ),
                      SizedBox(height: 46),
                      InkWell(
                        onTap: () => model.doAction(),
                        child: Container(
                          width: size.width,
                          height: btnHeight,
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                balanceEquation,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textOnPrimary,
                                ),
                              ),
                              SizedBox(width: 8),
                              Image.asset(
                                'assets/test_tube.png',
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 46),
                      Text(model.displayText, style: TextStyle(fontSize: 24)),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                (states) => TextStyle(
                  color:
                      states.contains(WidgetState.selected)
                          ? primaryColor
                          : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.science),
                  label: balanceEquation,
                ),
                NavigationDestination(
                  icon: Icon(Icons.table_chart_rounded),
                  label: periodicTable,
                ),
              ],
              onDestinationSelected: (int index) {
                /* Handle navigation */
              },
            ),
          ),
        );
      },
    );
  }

  InputBorder get border => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.grey.withAlpha(70), width: 3),
  );
}
