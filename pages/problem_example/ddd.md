# Сравнение подходов к реализации: rich domain model

```python {*}{maxHeight:'360px'}
@dataclass(slots=True)
class ProductAttributesEntity:
    id: str
    is_active: bool = True
    ready_to_sync: bool = False
    external_id: str | None = None
    
    def disable(self) -> None:
        self.is_active = False
        self.ready_to_sync = True
        self.external_id = None
        return None


@dataclass(slots=True)
class ProductEntity:
    id: str
    size_vo: ProductSizeValueObject
    product_attributes: list[ProductAttributesEntity]
    is_active: bool = True

    def disable(self) -> None:
        if not self.is_active:
            raise ProductAlreadyDisabledError(self.id)

        for attribute_entity in self.product_attributes:
            attribute_entity.disable()

        self.is_active = False
        return None


@dataclass(slots=True)
class ClassEntity:
    id: str
    is_active: bool = True
    products: list[ProductEntity]

    def get_product_by_id(self, product_id: str) -> ProductEntity | None:
        search_generator = (product for product in self.products if product.id == product_id)
        return next(search_generator, None)

    def get_active_products(self) -> list[ProductEntity]:
        return [product for product in self.products if product.is_active]

    def disable(self, *, product_id: str) -> None:
        if not self.is_active:
            raise ClassAlreadyDisabledError(product_id)

        active_products = self.get_active_products()

        if len(active_products) == 0:
            self.is_active = False

        return None


@dataclass(slots=True)
class ClassAggregate:
    root: ClassEntity

    def disable_product(self, *, product_id: str) -> None:
        product_entity = self.root.get_product_by_id(product_id)

        if product_entity is None:
            raise ProductNotFoundError(product_id)

        product_entity.disable()
        self.root.disable(product_id=product_id)
        

class ProductImportApplicationService:
    uow: UnitOfWork

    def disable_product(self, product_id: str) -> None:
        with self.uow:
            class_aggregate = self.uow.class_repository.get_by_product_id(product_id)
            class_aggregate.disable_product(product_id)
            self.uow.class_repository.save(class_aggregate)
            self.uow.commit()

```
<SlideCurrentNo class="absolute bottom-[5px] left-1/2 transform -translate-x-1/2 items-center" />
