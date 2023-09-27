// lib/providers/data_provider.dart
import 'package:flutter/foundation.dart';

class WorkHistory {
  String company;
  String role;
  DateTime startDate;
  DateTime endDate; // Add this line

  WorkHistory({
    required this.company,
    required this.role,
    required this.startDate,
    required this.endDate, // Add this line
  });
}

class CVDataProvider extends ValueNotifier<Map<String, dynamic>> {
  CVDataProvider()
      : super({
          'professionalSummary':
              'I am a budding Data Scientist and an aspiring Mobile Engineer.',
          'personalDetails': {
            'Slack Profile Picture':
                'https://ca.slack-edge.com/T05FFAA91JP-U05RAGFQYCA-06b6c3e635ed-192',
            'Name': 'Oladimeji Williams',
            'Slack': 'Oladimeji Williams',
            'GitHub': 'Oladimeji-Williams',
            'About':
                'I obtained Diploma and Bachelors in Electrical/Electronics Engineering from Lagos State Polytechnic and University of Lagos respectively.',
          },
          'professionalDetails': [
            WorkHistory(
              company: 'HNGx',
              role: 'Mobile Development Intern',
              startDate: DateTime.parse('2023-09-01'),
              endDate: DateTime.parse('2023-09-14'),
            ),
            WorkHistory(
              company: 'AXA mansard',
              role: 'Data Analytics',
              startDate: DateTime.parse('2023-04-24'),
              endDate: DateTime.parse('2023-09-14'),
            ),
          ],
        });

  List<WorkHistory> get workHistories =>
      value['professionalDetails'] as List<WorkHistory>;

  void updateWorkHistories(List<WorkHistory> histories) {
    value['professionalDetails'] = histories;
    notifyListeners();
  }

  void addWorkHistory(WorkHistory history) {
    (value['professionalDetails'] as List<WorkHistory>).add(history);
    notifyListeners();
  }

  void updateFullName(String fullName) {
    value['personalDetails']['fullName'] = fullName;
    notifyListeners();
  }

  void updateSlackUsername(String slackUsername) {
    value['personalDetails']['slackUsername'] = slackUsername;
    notifyListeners();
  }

  void updateGithubHandle(String githubHandle) {
    value['personalDetails']['githubHandle'] = githubHandle;
    notifyListeners();
  }

  void updatePersonalDetails(Map<String, String> details) {
    value['personalDetails'] = {...value['personalDetails'], ...details};
    notifyListeners();
  }

  void addPersonalDetail(String key, String detailValue) {
    value['personalDetails'][key] = detailValue;
    notifyListeners();
  }

  void editPersonalDetail(String key, String detailValue) {
    value['personalDetails'][key] = detailValue;
    notifyListeners();
  }

  void updateWorkHistory(int index, WorkHistory updatedHistory) {
    List<WorkHistory> currentHistories =
        value['professionalDetails'] as List<WorkHistory>;
    if (index >= 0 && index < currentHistories.length) {
      currentHistories[index] = updatedHistory;
      value = {...value, 'professionalDetails': currentHistories};
      notifyListeners();
    }
  }

  void editWorkHistory(int index, WorkHistory newHistory) {
    (value['professionalDetails'] as List<WorkHistory>)[index] = newHistory;
    notifyListeners();
  }

  String getProfessionalSummary() {
    return value['professionalSummary'] as String;
  }

  void updateProfessionalSummary(String summary) {
    value['professionalSummary'] = summary;
    notifyListeners();
  }
}
