
local MetaProduct = class("MetaProduct", function()
    return {}
end)

function MetaProduct.create(productId,
    productName,
    productDescription,
    productValue)

    local obj = MetaProduct.new()

    obj.productId = productId
    obj.productName = productName
    obj.productDescription = productDescription
    obj.productValue = productValue

    return obj
end

return MetaProduct
