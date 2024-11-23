# Сравнение подходов к реализации: rich domain model

```python {*}{maxHeight:'360px'}
@dataclass(slots=True)
class ProductEntity:
    size_vo: ProductSizeValueObject
    product_attributes: list[ProductAttributes]
    is_active: bool = True


@dataclass(slots=True)
class ClassAggregate:
    is_active: bool = True
    products: list[ProductEntity]

    def get_product_by_id(self, product_id: str) -> ProductEntity | None:
        search_generator = (product for product in self.products if product.id == product_id)
        return next(search_generator, None)
    
    def get_active_products(self) -> list[ProductEntity]:
        return [product for product in self.products if product.is_active]
        
    def disable_product(self, *, product_id: str) -> None:
        product = self.get_product_by_id(product_id)

        if product is None:
            raise ProductNotFoundError(product_id)

        if self.is_active:
            raise ProductDisableError(product_id)
        
        if not product.is_active:
            raise ProductAlreadyDisabledError(product_id)

        product.is_active = False

        for product_attribute in self.product_attributes:
            product_attribute.is_active = False
            product_attribute.ready_sync = True
            product_attribute.external_id = None

        active_products = self.get_active_products()

        if len(active_products) == 0:
            self.is_active = False
        

class ProductImportApplicationService:
    uow: UnitOfWork

    def disable_product(self, product_id: str) -> None:
        with self.uow:
            class_aggregate = self.uow.class_repository.get_by_product_id(product_id)

        class_aggregate.disable_product(product_id)

        with self.uow:
            self.uow.class_repository.save(class_aggregate)
            uow.commit()

```
<SlideCurrentNo class="absolute bottom-[5px] left-1/2 transform -translate-x-1/2 items-center" />
