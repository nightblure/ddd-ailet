# DDD и архитектура - паттерн Unit of Work

```python {*}{maxHeight:'400px'}
class UnitOfWork:
    _db_session: Session | None = None
    db_session_factory: Callable[..., Session]
    
    @property
    def db_session(self) -> Session:
        if self._db_session is None:
            msg = 'Unit of work should be used ONLY with context manager!'
            raise Exception(msg)
        return self._db_session
    
    def __enter__(self):
        session = self.db_session_factory()
        self._db_session = session

        self.some_dao = SomeDAO(session)
        self.another_dao = AnotherDAO(session)
        self.class_repository = ClassRepository(session)
        
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if exc_type is not None:
            self._db_session.rollback()

        self._db_session.close()
        self._db_session = None
    
    def commit(self) -> None:
        self._db_session.commit()

"""
* абстрагирует от конкретной реализации «сессии»;
* удобный доступ к любым DAO и репозиториям;
* во всех местах одинаковая и правильная практика использования;
* в местах использования явно станут видны начало и конец транзакции;
* гарантирует закрытие соединения в конце работы;
* гарантирует откат транзакции в случае возникновения исключительных ситуаций.
"""
```
<SlideCurrentNo class="absolute bottom-[5px] left-1/2 transform -translate-x-1/2 items-center" />
