import 'package:entrenaop/features/routines/domain/entities/routine_entity.dart';
import 'package:entrenaop/features/routines/domain/repositories/routine_repository.dart';

class GetAssignedRoutinesUseCase {
  final RoutineRepository repository;
  GetAssignedRoutinesUseCase(this.repository);

  Future<List<RoutineEntity>> call(String userId) async {
    return await repository.getAssignedRoutines(userId);
  }
}
