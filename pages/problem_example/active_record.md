# Сравнение подходов к реализации: active record

```python {*}{maxHeight:'400px'}
class ProductDbEntity:
    is_active = Column(Boolean)
    product_attributes = relationship("ProductAttributes", foreign_keys="ProductAttributes.product_id")
    

class ClassDbEntity:
    is_active = Column(Boolean)
    products = relationship("Product", foreign_keys="Product.class_id")

    def get_product_by_id(self, product_id: str) -> ProductDbEntity | None:
        search_generator = (product for product in self.products if product.id == product_id)
        return next(search_generator, None)

    def get_active_products(self) -> list[ProductDbEntity]:
        return [product for product in self.products if product.is_active]

    def disable_product(self, *, product_id: str) -> None:
        product = self.get_product_by_id(product_id)

        if product is None:
            raise ProductNotFoundError(product_id)

        if not product.is_active:
            raise ProductAlreadyDisabledError(product_id)

        if self.is_active:
            raise ProductDisableError(product_id)

        product.is_active = False

        for product_attribute in product.product_attributes:
            product_attribute.is_active = False
            product_attribute.ready_sync = True
            product_attribute.external_id = None

        active_products = self.get_active_products()

        if len(active_products) == 0:
            self.is_active = False


class ProductImportService:
    class_dao: ClassDAO
    db_session_factory: Callable[..., Session]

    def disable_product(self, product_id: str):
        with self.db_session_factory() as db_session:
            class_ = self.class_dao.get_by_product_id(product_id, db_session)
            class_.disable_product(product_id)
            db_session.commit()
            return ...

```
<SlideCurrentNo class="absolute bottom-[5px] left-1/2 transform -translate-x-1/2 items-center" />
