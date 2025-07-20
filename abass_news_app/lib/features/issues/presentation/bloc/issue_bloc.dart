import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/issue_entity.dart';
import '../../domain/usecases/create_issue_usecase.dart';
import '../../domain/usecases/get_all_issues_usecase.dart';
import '../../domain/usecases/get_user_issues_usecase.dart';
import '../../domain/usecases/update_issue_status_usecase.dart';

part 'issue_event.dart';
part 'issue_state.dart';

@injectable
class IssueBloc extends Bloc<IssueEvent, IssueState> {
  final GetAllIssuesUseCase _getAllIssuesUseCase;
  final GetUserIssuesUseCase _getUserIssuesUseCase;
  final CreateIssueUseCase _createIssueUseCase;
  final UpdateIssueStatusUseCase _updateIssueStatusUseCase;

  IssueBloc(
    this._getAllIssuesUseCase,
    this._getUserIssuesUseCase,
    this._createIssueUseCase,
    this._updateIssueStatusUseCase,
  ) : super(IssueInitial()) {
    on<LoadAllIssues>(_onLoadAllIssues);
    on<LoadUserIssues>(_onLoadUserIssues);
    on<CreateIssue>(_onCreateIssue);
    on<UpdateIssueStatus>(_onUpdateIssueStatus);
  }

  Future<void> _onLoadAllIssues(
    LoadAllIssues event,
    Emitter<IssueState> emit,
  ) async {
    emit(IssueLoading());

    final result = await _getAllIssuesUseCase();

    result.fold(
      (failure) => emit(IssueError(failure.message)),
      (issues) => emit(IssuesLoaded(issues)),
    );
  }

  Future<void> _onLoadUserIssues(
    LoadUserIssues event,
    Emitter<IssueState> emit,
  ) async {
    emit(IssueLoading());

    final result = await _getUserIssuesUseCase();

    result.fold(
      (failure) => emit(IssueError(failure.message)),
      (issues) => emit(UserIssuesLoaded(issues)),
    );
  }

  Future<void> _onCreateIssue(
    CreateIssue event,
    Emitter<IssueState> emit,
  ) async {
    emit(IssueLoading());

    final result = await _createIssueUseCase(
      title: event.title,
      description: event.description,
      imageUrl: event.imageUrl,
      attachments: event.attachments,
    );

    result.fold(
      (failure) => emit(IssueError(failure.message)),
      (issue) => emit(IssueCreated(issue)),
    );
  }

  Future<void> _onUpdateIssueStatus(
    UpdateIssueStatus event,
    Emitter<IssueState> emit,
  ) async {
    emit(IssueLoading());

    final result = await _updateIssueStatusUseCase(
      id: event.id,
      status: event.status,
      adminNotes: event.adminNotes,
    );

    result.fold(
      (failure) => emit(IssueError(failure.message)),
      (issue) => emit(IssueStatusUpdated(issue)),
    );
  }
}
