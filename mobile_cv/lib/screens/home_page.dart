// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_cv/providers/data_provider.dart';
import 'package:mobile_cv/screens/webview_screen.dart';

class HomePage extends StatelessWidget {
  void _openWebView(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(url: url),
      ),
    );
  }

  final CVDataProvider dataProvider;

  const HomePage(this.dataProvider, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil
    ScreenUtil.init(context, designSize: const Size(360, 690));

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 600) {
          // For tablets
          return _buildView(context, 24.sp, 20.sp);
        } else {
          // For phones
          return _buildView(context, 18.sp, 16.sp);
        }
      },
    );
  }

  Scaffold _buildView(
      BuildContext context, double headerSize, double contentSize) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text("Personal Profile Page", style: TextStyle(fontSize: 18.sp)),
          backgroundColor: Colors.deepPurple),
      body: ValueListenableBuilder<Map<String, dynamic>>(
          valueListenable: dataProvider,
          builder: (context, data, child) {
            // Here is where you retrieve the Slack profile picture URL
            String? slackProfilePictureUrl =
                data['personalDetails']['Slack Profile Picture'];

            return Padding(
              padding: EdgeInsets.all(16.w),
              child: ListView(
                children: [
                  if (data.containsKey('professionalSummary'))
                    Row(
                      children: [
                        // Left: The Professional Summary title and content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Professional Summary",
                                style: TextStyle(
                                  fontSize: contentSize.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              SizedBox(
                                  height: 8
                                      .h), // Some vertical space between title and content
                              Text(
                                data['professionalSummary'],
                                style: TextStyle(fontSize: contentSize),
                              ),
                            ],
                          ),
                        ),

                        // Right: The Slack profile picture
                        if (slackProfilePictureUrl != null &&
                            slackProfilePictureUrl.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                                left:
                                    12.0), // Some space between text and image
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black45,
                                    offset: Offset(0, 3), // Shadow position
                                    blurRadius: 5.0, // Shadow blur
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  slackProfilePictureUrl,
                                  fit: BoxFit.cover,
                                  width: 60.w,
                                  height: 60.h,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return const Icon(Icons.error,
                                        size:
                                            60.0); // Display an error icon in case of failure
                                  },
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                  SizedBox(
                      height:
                          8.h), // Some vertical space between title and content

                  SizedBox(height: 20.h),
                  const Divider(color: Colors.deepPurple),
                  Text(
                    "Personal Details",
                    style: TextStyle(
                        fontSize: contentSize.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),
                  // Adjust this section to exclude the 'Slack Profile Picture' key
                  if (data.containsKey('personalDetails'))
                    ...Map<String, String>.from(data['personalDetails'])
                        .entries
                        .where(
                            (detail) => detail.key != 'Slack Profile Picture')
                        .map(
                          /*... your existing code ...*/
                          (detail) => Row(
                            children: <Widget>[
                              SizedBox(
                                width: 50.w, // Adjust this width as necessary
                                child: Text(
                                  "${detail.key}:",
                                  style: TextStyle(
                                    fontSize: contentSize - 4.sp,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w), // horizontal space
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (detail.key == 'GitHub') {
                                      _openWebView(context,
                                          'https://github.com/${detail.value}');
                                    }
                                  },
                                  child: Text(
                                    detail.value,
                                    style: TextStyle(
                                      fontSize: contentSize.sp,
                                      decoration: (detail.key == 'GitHub')
                                          ? TextDecoration.underline
                                          : null,
                                      color: (detail.key == 'GitHub')
                                          ? Colors.blue
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(height: 20.h),
                  const Divider(color: Colors.deepPurple),
                  Text(
                    "Professional Details",
                    style: TextStyle(
                        fontSize: headerSize.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),
                  if (data.containsKey('professionalDetails'))
                    ...List.generate(
                      (data['professionalDetails'] as List).length,
                      (index) {
                        WorkHistory history = (data['professionalDetails']
                            as List<WorkHistory>)[index];
                        return ListTile(
                          leading: Icon(Icons.fiber_manual_record,
                              size: 12.w, color: Colors.deepPurple),
                          title: Text(
                            "${history.company} - ${history.role}",
                            style: TextStyle(fontSize: contentSize),
                          ),
                          subtitle: Text(
                            "${history.startDate.toLocal().toString().split(' ')[0]} to ${history.endDate.toLocal().toString().split(' ')[0]}",
                            style: TextStyle(fontSize: contentSize - 2.sp),
                          ),
                          trailing:
                              const Icon(Icons.edit, color: Colors.deepPurple),
                        );
                      },
                    ),
                ],
              ),
            );
          } // Close the builder function
          ), // Close the ValueListenableBuilder
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.pushNamed(context, '/edit'),
        child: const Icon(Icons.edit),
      ),
    );
  }
}
