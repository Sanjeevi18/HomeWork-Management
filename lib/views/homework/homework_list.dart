import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/homework_controller.dart';
import 'add_homework_bottomsheet.dart';

class HomeworkListScreen extends StatelessWidget {
  final AuthController authController = Get.find();
  final HomeworkController homeworkController = Get.put(HomeworkController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Homework'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.signOut(),
          ),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            // Summary Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem(
                        'Pending',
                        homeworkController.pendingCount.toString(),
                        Colors.white,
                      ),
                      _buildSummaryItem(
                        'Completed',
                        homeworkController.completedCount.toString(),
                        Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: homeworkController.progressPercent,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(homeworkController.progressPercent * 100).toInt()}% Complete',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Homework List
            Expanded(
              child: homeworkController.homeworkList.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No homework yet!',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap + to add your first homework',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: homeworkController.homeworkList.length,
                      itemBuilder: (context, index) {
                        final homework = homeworkController.homeworkList[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: Checkbox(
                              value: homework.isCompleted,
                              onChanged: (value) {
                                if (!homework.isCompleted) {
                                  homeworkController.markAsCompleted(
                                    homework.id,
                                  );
                                }
                              },
                            ),
                            title: Text(
                              homework.title,
                              style: TextStyle(
                                decoration: homework.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Text(
                              'Due: ${homework.dueDate.day}/${homework.dueDate.month}/${homework.dueDate.year}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => homeworkController
                                  .deleteHomework(homework.id),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => AddHomeworkBottomSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(color: color.withOpacity(0.8))),
      ],
    );
  }
}
