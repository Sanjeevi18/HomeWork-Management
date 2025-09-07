import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/homework_controller.dart';
import '../../app/themes.dart';
import 'add_homework_bottomsheet.dart';

class HomeworkListScreen extends StatelessWidget {
  final AuthController authController = Get.find();
  final HomeworkController homeworkController = Get.put(HomeworkController());

  // Filter state
  final RxString currentFilter = 'all'.obs; // 'all', 'pending', 'completed'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My Homework',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppThemes.color1,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppThemes.color1.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: AppThemes.color1,
                  size: 24,
                ),
              ),
              onPressed: () => Get.toNamed('/profile'),
            ),
          ),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            // Summary Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppThemes.color1, AppThemes.color2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppThemes.color1.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
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
                        Icons.pending_actions,
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      _buildSummaryItem(
                        'Completed',
                        homeworkController.completedCount.toString(),
                        Colors.white,
                        Icons.check_circle_outline,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: LinearProgressIndicator(
                      value: homeworkController.homeworkList.length > 0
                          ? homeworkController.completedCount /
                                homeworkController.homeworkList.length
                          : 0,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${((homeworkController.homeworkList.length > 0 ? homeworkController.completedCount / homeworkController.homeworkList.length : 0) * 100).toInt()}% Complete',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Filter Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Obx(
                () => Row(
                  children: [
                    _buildFilterChip('All', 'all'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Pending', 'pending'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Completed', 'completed'),
                  ],
                ),
              ),
            ),

            // Homework List
            Expanded(
              child: homeworkController.isLoading.value
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppThemes.color1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading homework...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _getFilteredHomework().isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: AppThemes.color1.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              Icons.assignment_outlined,
                              size: 60,
                              color: AppThemes.color1,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No homework yet!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppThemes.color1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add your first homework to get started',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _getFilteredHomework().length,
                      itemBuilder: (context, index) {
                        final homework = _getFilteredHomework()[index];
                        final isOverdue =
                            homework.dueDate.isBefore(DateTime.now()) &&
                            !homework.isCompleted;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: homework.isCompleted
                                ? AppThemes.color2.withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: homework.isCompleted
                                  ? AppThemes.color2
                                  : isOverdue
                                  ? AppThemes.color5.withOpacity(0.3)
                                  : AppThemes.color1.withOpacity(0.2),
                              width: homework.isCompleted ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: homework.isCompleted
                                    ? AppThemes.color2.withOpacity(0.2)
                                    : isOverdue
                                    ? AppThemes.color5.withOpacity(0.1)
                                    : AppThemes.color1.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: homework.isCompleted
                                    ? AppThemes.color2.withOpacity(0.3)
                                    : AppThemes.color1.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: homework.isCompleted
                                    ? Border.all(
                                        color: AppThemes.color2,
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: Icon(
                                homework.isCompleted
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: homework.isCompleted
                                    ? AppThemes.color2
                                    : AppThemes.color1,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              homework.title,
                              style: TextStyle(
                                decoration: homework.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: homework.isCompleted
                                    ? AppThemes.color2.withOpacity(0.8)
                                    : Colors.black87,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: isOverdue
                                          ? AppThemes.color5
                                          : homework.isCompleted
                                          ? AppThemes.color2
                                          : Colors.grey[600],
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Due: ${homework.dueDate.day}/${homework.dueDate.month}/${homework.dueDate.year}',
                                      style: TextStyle(
                                        color: isOverdue
                                            ? AppThemes.color5
                                            : homework.isCompleted
                                            ? AppThemes.color2
                                            : Colors.grey[600],
                                        fontWeight: isOverdue
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                if (homework.isCompleted) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline,
                                        size: 14,
                                        color: AppThemes.color2,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Completed',
                                        style: TextStyle(
                                          color: AppThemes.color2,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: AppThemes.color5,
                              ),
                              onPressed: () => homeworkController
                                  .deleteHomework(homework.id),
                            ),
                            onTap: homework.isCompleted
                                ? null
                                : () {
                                    homeworkController.markAsCompleted(
                                      homework.id,
                                    );
                                  },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppThemes.color1, AppThemes.color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppThemes.color1.withOpacity(0.4),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Get.bottomSheet(
              AddHomeworkBottomSheet(),
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.9),
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Filter methods
  Widget _buildFilterChip(String label, String value) {
    final isSelected = currentFilter.value == value;
    return GestureDetector(
      onTap: () => currentFilter.value = value,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppThemes.color1 : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppThemes.color1 : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  List<dynamic> _getFilteredHomework() {
    switch (currentFilter.value) {
      case 'pending':
        return homeworkController.homeworkList
            .where((h) => !h.isCompleted)
            .toList();
      case 'completed':
        return homeworkController.homeworkList
            .where((h) => h.isCompleted)
            .toList();
      default:
        return homeworkController.homeworkList;
    }
  }
}
