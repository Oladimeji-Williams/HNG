// lib/screens/edit_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_cv/providers/data_provider.dart';

extension StringExtension on String {
  String get capitalizeFirst =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
}

class EditPage extends StatefulWidget {
  final CVDataProvider dataProvider;

  const EditPage(this.dataProvider, {Key? key}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class WorkHistoryControllers {
  TextEditingController company;
  TextEditingController role;
  DateTime? startDate;
  DateTime? endDate; // Add this line

  WorkHistoryControllers({
    required this.company,
    required this.role,
    required this.startDate,
    this.endDate, // Add this line
  });
}

class _EditPageState extends State<EditPage> {
  final professionalSummaryController = TextEditingController();
  final fullNameController = TextEditingController();
  final slackUsernameController = TextEditingController();
  final githubHandleController = TextEditingController();
  final personalBioController = TextEditingController();
  final companyController = TextEditingController();
  final roleController = TextEditingController();
  DateTime? selectedDate;
  DateTime? newWorkHistoryStartDate;
  DateTime? newWorkHistoryEndDate;

  List<TextEditingController> personalDetailsControllers = [];
  Map<String, TextEditingController> personalDetailsControllersMap = {};
  List<WorkHistoryControllers> workHistoryControllersList = [];

  @override
  void initState() {
    super.initState();
    professionalSummaryController.text =
        widget.dataProvider.getProfessionalSummary();
    fullNameController.text =
        widget.dataProvider.value['personalDetails']['Full Name'] ?? "";
    slackUsernameController.text =
        widget.dataProvider.value['personalDetails']['Slack Username'] ?? "";
    githubHandleController.text =
        widget.dataProvider.value['personalDetails']['GitHub Handle'] ?? "";
    // Initialize other controllers similarly if needed...
    Map<String, String> personalDetails =
        Map<String, String>.from(widget.dataProvider.value['personalDetails']);

    personalDetails.forEach((key, value) {
      personalDetailsControllersMap[key] = TextEditingController(text: value);
    });
    List<WorkHistory> workHistories =
        widget.dataProvider.value['professionalDetails'];
    workHistories.forEach((history) {
      workHistoryControllersList.add(WorkHistoryControllers(
        company: TextEditingController(text: history.company),
        role: TextEditingController(text: history.role),
        startDate: history.startDate,
        endDate: history.endDate, // Add this line
      ));
    });
  }

  void _saveAllData() {
    // 1. Save personal details
    Map<String, String> updatedDetails = {};
    personalDetailsControllersMap.forEach((key, controller) {
      updatedDetails[key] = controller.text;
    });
    widget.dataProvider.updatePersonalDetails(updatedDetails);

    // 2. Save professional summary
    widget.dataProvider
        .updateProfessionalSummary(professionalSummaryController.text);

    // 3. Save all work histories
    // Update all work histories
    List<WorkHistory> updatedWorkHistories = [];
    for (var controllers in workHistoryControllersList) {
      if (controllers.startDate != null) {
        // Ensure that the date is not null
        updatedWorkHistories.add(
          WorkHistory(
            company: controllers.company.text,
            role: controllers.role.text,
            startDate: controllers.startDate!,
            endDate: controllers.endDate!,
          ),
        );
      }
    }
    // Call the function to update the provider:
    widget.dataProvider.updateWorkHistories(updatedWorkHistories);

    // Return to the home page
    Navigator.pop(context);
  }

  void _addNewWorkHistory() {
    if (newWorkHistoryStartDate == null || newWorkHistoryEndDate == null) {
      return; // Ensure that both dates are not null
    }

    // Create new work history
    WorkHistory newHistory = WorkHistory(
      company: companyController.text,
      role: roleController.text,
      startDate: newWorkHistoryStartDate!,
      endDate: newWorkHistoryEndDate!,
    );

    // Add to data provider
    widget.dataProvider.addWorkHistory(newHistory);

    // Add to local controllers list to reflect on UI immediately
    workHistoryControllersList.add(
      WorkHistoryControllers(
        company: TextEditingController(text: newHistory.company),
        role: TextEditingController(text: newHistory.role),
        startDate: newHistory.startDate,
        endDate: newHistory.endDate,
      ),
    );

    companyController.clear();
    roleController.clear();
    setState(() {
      newWorkHistoryStartDate = null;
      newWorkHistoryEndDate = null;
    });
  }

// Inside _EditPageState
  List<MapEntry<String, TextEditingController>> additionalFields = [];

  List<Widget> _buildPersonalDetailFields() {
    List<Widget> fields = [];

    for (var key in personalDetailsControllersMap.keys) {
      fields.add(
        ListTile(
          title: TextField(
            controller: personalDetailsControllersMap[key],
            decoration: InputDecoration(labelText: key.capitalizeFirst),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _updatePersonalDetail(
                key, personalDetailsControllersMap[key]!.text),
          ),
        ),
      );
    }

    // Handle the new fields
    for (var entry in additionalFields) {
      fields.add(
        ListTile(
          title: TextField(
            controller: entry.value,
            decoration: InputDecoration(
                labelText: entry.key.capitalizeFirst,
                hintText: "Enter ${entry.key.capitalizeFirst}"),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              widget.dataProvider
                  .editPersonalDetail(entry.key, entry.value.text);
            },
          ),
        ),
      );
    }

    fields.add(ElevatedButton(
      onPressed: _addNewFieldDialog, // Open a dialog to add a new field
      child: const Text('Add More Personal Details'),
    ));

    return fields;
  }

  void _addNewFieldDialog() async {
    TextEditingController fieldController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Field"),
        content: TextField(
          controller: fieldController,
          decoration: const InputDecoration(
              hintText: "Enter field name (e.g., Address)"),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text("Add"),
            onPressed: () {
              String fieldName = fieldController.text;
              setState(() {
                TextEditingController newController = TextEditingController();
                personalDetailsControllersMap[fieldName] =
                    newController; // add to map
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _updatePersonalDetail(String key, String newValue) {
    widget.dataProvider.editPersonalDetail(key, newValue);
  }

  List<Widget> _buildWorkHistoryFields() {
    List<Widget> fields = [];

    for (int i = 0; i < workHistoryControllersList.length; i++) {
      fields.add(
        Column(
          children: [
            TextField(
              controller: workHistoryControllersList[i].company,
              decoration: const InputDecoration(labelText: 'Company'),
            ),
            TextField(
              controller: workHistoryControllersList[i].role,
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            ListTile(
              title: Text(
                workHistoryControllersList[i]
                        .startDate
                        ?.toLocal()
                        .toString()
                        .split(' ')[0] ??
                    'Select Date',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? pickedStartDate = await showDatePicker(
                  context: context,
                  initialDate:
                      workHistoryControllersList[i].startDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (pickedStartDate != null) {
                  setState(() {
                    workHistoryControllersList[i].startDate = pickedStartDate;
                  });
                }
              },
            ),
            ListTile(
              title: Text(
                workHistoryControllersList[i]
                        .endDate
                        ?.toLocal()
                        .toString()
                        .split(' ')[0] ??
                    'Select Date',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? pickedEndDate = await showDatePicker(
                  context: context,
                  initialDate:
                      workHistoryControllersList[i].endDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (pickedEndDate != null) {
                  setState(() {
                    workHistoryControllersList[i].endDate = pickedEndDate;
                  });
                }
              },
            ),
          ],
        ),
      );
    }

    // Rest of your function for adding new work history:
    fields.add(TextField(
      controller: companyController,
      decoration: const InputDecoration(labelText: 'Company'),
    ));
    fields.add(TextField(
      controller: roleController,
      decoration: const InputDecoration(labelText: 'Role'),
    ));
    fields.add(ListTile(
      title: Text(
        newWorkHistoryStartDate?.toLocal().toString().split(' ')[0] ??
            'Select Start Date',
      ),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        DateTime? pickedStartDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (pickedStartDate != null) {
          setState(() {
            newWorkHistoryStartDate = pickedStartDate;
          });
        }
      },
    ));

    fields.add(ListTile(
      title: Text(
        newWorkHistoryEndDate?.toLocal().toString().split(' ')[0] ??
            'Select End Date',
      ),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        DateTime? pickedEndDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (pickedEndDate != null) {
          setState(() {
            newWorkHistoryEndDate = pickedEndDate;
          });
        }
      },
    ));

    return fields;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 600) {
          return _tabletView();
        } else {
          return _phoneView();
        }
      },
    );
  }

  Widget _tabletView() {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Edit CV for Tablet"),
          backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: _commonWidgets(),
        ),
      ),
    );
  }

  Widget _phoneView() {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Edit CV for Phone"),
          backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: _commonWidgets(),
        ),
      ),
    );
  }

  List<Widget> _commonWidgets() {
    return [
      TextField(
        controller: professionalSummaryController,
        maxLines: 3,
        decoration:
            const InputDecoration(labelText: "Edit your professional summary"),
      ),
      const SizedBox(height: 20),
      ..._buildPersonalDetailFields(),
      const SizedBox(height: 20),
      const Divider(color: Colors.deepPurple),
      ..._buildWorkHistoryFields(),
      ElevatedButton(
        onPressed: _addNewWorkHistory,
        child: const Text('Add New Work History'),
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: _saveAllData,
        child: const Text('Save All'),
      ),
    ];
  }
}
