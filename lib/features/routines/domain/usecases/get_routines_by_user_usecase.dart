import 'package:entrenaop/features/routines/domain/entities/routine_entity.dart';
import 'package:entrenaop/features/routines/domain/repositories/routine_repository.dart';

class GetRoutinesByUserUseCase {
  final RoutineRepository repository;
  GetRoutinesByUserUseCase(this.repository);

  Future<List<RoutineEntity>> call(String userId) async {
    return await repository.getRoutinesByUser(userId);
  }
}
