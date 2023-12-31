import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residencekeeper/components/payment_component.dart';
import 'package:residencekeeper/main.dart';
import 'package:residencekeeper/models/category_model.dart';
import 'package:residencekeeper/models/payment_model.dart';
import 'package:residencekeeper/models/residence_model.dart';
import 'package:residencekeeper/pages/settings_residence_page%20copy.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

class ResidenceDetailedPage extends StatefulWidget {
  final int id;
  ResidenceDetailedPage({Key? key, required this.id}) : super(key: key);

  @override
  _ResidenceDetailedPageState createState() => _ResidenceDetailedPageState();
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

class _ResidenceDetailedPageState extends State<ResidenceDetailedPage> {
  late Future<ResidenceModel> residence;

  @override
  void initState() {
    super.initState();
    residence = ResidenceModel.getResidenceDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_vert, // Icône de trois points
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(residence: residence),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<ResidenceModel>(
        future: residence,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            // Afficher les données récupérées ici
            final residenceData = snapshot.data;
            if (residenceData != null) {
              final paymentList = residenceData.payments;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Your Balance",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        )),
                    SizedBox(height: 20),
                    for (var user in residenceData.balance.users)
                      if (user.userId == 1)
                        Text(
                          user.balance < 0
                              ? '-\$${(-user.balance).toStringAsFixed(2)}'
                              : '\$${user.balance.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 40,
                            color: residenceData.balance.balance < 0
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),

                    Text(
                      residenceData.balance.balance < 0
                          ? '-\$${(-residenceData.balance.balance).toStringAsFixed(2)}'
                          : '\$${residenceData.balance.balance.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: residenceData.balance.balance < 0
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                    SizedBox(height: 40),
                    // SfCircularChart(series: <CircularSeries>[
                    //   // Render pie chart
                    //   RadialBarSeries<ChartData, String>(
                    //       dataSource: [
                    //         // Bind data source
                    //         ChartData('Jan', 35),
                    //         ChartData('Feb', 28),
                    //         ChartData('Mar', 34),
                    //         ChartData('Apr', 32),
                    //         ChartData('May', 40)
                    //       ],
                    //       xValueMapper: (ChartData data, _) => data.x,
                    //       yValueMapper: (ChartData data, _) => data.y)
                    // ]),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: paymentList.length,
                      itemBuilder: (context, index) {
                        final payment = paymentList[index];
                        return Payment(payment: payment);
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Aucun paiement trouvé.'));
            }
          }
        },
      ),
      floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: d_main, // Couleur de fond du bouton flottant
            shape: BoxShape.circle, // Forme du bouton
          ),
          child: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled:
                    true, // Définit la hauteur en fonction du contenu
                builder: (context) {
                  return ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          bottom: 16.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            AddingExpenseForm(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Icon(Icons.add),
            backgroundColor: d_main, // Icône du bouton flottant
          )),
    );
  }
}

class AddingExpenseForm extends StatefulWidget {
  @override
  _AddingExpenseFormState createState() => _AddingExpenseFormState();
}

class _AddingExpenseFormState extends State<AddingExpenseForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name = '';
  String _amount = '';
  String _date = '';
  int selectedCategory = 0;
  bool isExpense = true;
  List<String> expenseType = ['Expense', 'Income'];
  double _sliderValue = 50.0;
  bool isAdvancedOpen = false;

  void toggleAdvanced() {
    setState(() {
      isAdvancedOpen = !isAdvancedOpen;
    });
  }

  // Utilisez FutureBuilder pour obtenir la liste des catégories.
  Future<List<CategoryModel>> categories = CategoryModel.getCategories();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Traitement et soumission des données du formulaire
      PaymentModel payment = new PaymentModel(
        userId: 1,
        homeId: 1,
        amount: double.parse(_amount),
        date: _date,
        name: _name,
        categoryId: selectedCategory,
        isExpense: isExpense,
      );
      payment.newPayment();
      setState(() {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Expense Title',
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the expense name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value!;
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            TextFormField(
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                hintText: 'Amount',
                hintStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                prefixStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: d_main,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty || double.tryParse(value) == null) {
                  // Assurez-vous que la valeur est un nombre.
                  return 'Please enter a valid amount';
                }
                return null;
              },
              onSaved: (value) {
                _amount = value!;
              },
            ),
            TextFormField(
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                hintText: 'Date',
                hintStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a date';
                }
                return null;
              },
              onSaved: (value) {
                _date = value!;
              },
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Type of transaction",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: expenseType.map((String expense) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (expense == "Expense")
                        isExpense = true;
                      else
                        isExpense = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: (isExpense && expense == "Expense") ||
                              (!isExpense && expense == "Income")
                          ? d_main
                          : Color(0xffe8ebf0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      expense,
                      style: GoogleFonts.poppins(
                        color: (isExpense && expense == "Expense") ||
                                (!isExpense && expense == "Income")
                            ? Colors.white
                            : null,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select Category",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 10),
            FutureBuilder<List<CategoryModel>>(
              future: categories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<CategoryModel> categoryList = snapshot.data ?? [];

                  return Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: categoryList.map((CategoryModel category) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category.id;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: category.id == selectedCategory
                                ? d_main
                                : Color(0xffe8ebf0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            category.name,
                            style: GoogleFonts.poppins(
                              color: category.id == selectedCategory
                                  ? Colors.white
                                  : null,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: toggleAdvanced,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text("More Options",
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: d_main)),
                  ),
                  if (isAdvancedOpen)
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            // Slider(
                            //   value: _sliderValue,
                            //   min: 0,
                            //   max: 100,
                            //   onChanged: (double value) {
                            //     setState(() {
                            //       _sliderValue = value;
                            //     });
                            //   },
                            // ),
                          ],
                        )),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: d_main,
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: _submitForm,
              child:
                  Text('Add', style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
