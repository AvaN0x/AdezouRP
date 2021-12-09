-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local nextRequestId = 0
local requests = {}

RegisterNUICallback("base64treated", function(data, cb)
    local request = requests[data.id]
    if not request then
        return
    end

    for x = 0, request.width - 1 do
        for y = 0, request.height - 1 do
            local pos<const> = (x + y * request.height) * 4
            SetRuntimeTexturePixel(request.texture, x, y, data.argb[tostring(pos + 0)], data.argb[tostring(pos + 1)], data.argb[tostring(pos + 2)],
                data.argb[tostring(pos + 3)])
            CommitRuntimeTexture(request.texture)
        end
    end

    request.promise:resolve()
    cb({success = true})
end)

function SetRuntimeTextureBase64(texture, base64, width, height)
    if not texture or not base64 then
        return false
    end
    width = width or 64
    height = height or 64

    local thisRequestId = nextRequestId
    -- can have up to 128 values (from 0 to 127)
    nextRequestId = nextRequestId < 127 and (nextRequestId + 1) or 0

    local p = promise.new()
    requests[thisRequestId] = {promise = p, width = width, height = height, texture = texture}

    SendNUIMessage({base64 = base64, id = thisRequestId, width = width, height = height})

    return Citizen.Await(p)
end
exports("SetRuntimeTextureBase64", SetRuntimeTextureBase64)

-- Example :
Citizen.CreateThread(function()
    -- mandatory wait!
    Wait(0)

    local imageBase64 =
        "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAAAXNSR0IArs4c6QAAEQ1JREFUeF7Nm11sI9d1x/+a4YyGHok7XHJpqZK1ZqRoLUcNqqC1vEK3hdXGG28SFHUSJED7EKAvBQK4SG2kCNqkQAs/+qE1kAZt0z60D8lDtwiKbLtNo8B20+2mixUCyGAsS+FKXZZaSgRpUiOOZjij4tyPmSGX2g+Kwe4BiOEMh8N7fvd/7j33g0MAjjBgmxjWsDhqsqdWDgOkVAUNP0DJc2Em/PDXzIQOKCo034fu+3BVFVBVeL4Pjd4D0BUFlUMPa017wKXkjxsaNIC483EABcdBSlXR8G3kDBNmQmMFsIMAputy58liAAiEHUR+/zwgDBTAuKbh/Cle82SlQw8aVDQDXusN30fOUEPn6ZrreewzTwDgWHjN254XAsgNaz8XJQwUwCXLQtX3QCq4F4C4lrUj7ryrKNCDAPRNGQK268IbEsoAQBBu1h3U287AwmGgAJZGLFgjvGxOW2jXceEcqTCGfHZ0FRHbqgLXD+ApgKkpqNgeTF2F23bZ940hwDkCHB8wE/w7OUPDjXoTjXbUjpyUxMAAZBIazhkmDCOAkVAYAIcKyhXOrBWoUBP8vSfCgmKcHLddnx0brgCgCJAxAASi0XZR2H8MFUAAMgkdWQMwEip3nnkaOU/vAoVfd6nlV9WORs72fBiyEZDUjiIFPPYASAEt8NpJJlS02j6ctgFjKGrKnSNew9LiMU7XfETyphAwxI0yDGptF812MLAwGFgILGUtVlRquakPl614y/WhCzm7AVeANqTCO/LhBgFUVWNq8AIOSVPEzdQjKjp00WZIYJoAOKgwGAiAzLCGjK4jO6wxAFLerEbbPmwf0OiXYiFg+x4D4YM7fC8ArmgvCAYBoEZwUCoYCIBZkfUx6UcVyJTguy7q7QiAE2sVSQX+EW/hqeYJQlwBumrCP4q1ogTUd5FijaGPktP5WUdsPeDJQABIBXQDkAog6Xsi4faHROJzxGNdGeKtHjlPyjG1qBWkEGCfsev8fctrPX4AZk2e/WU1LWwE6fzc9Ayuv7vRURfdHVirK6lJJmSzx7/WecZTZbIaKUtkkQ9Y2T1vG4gCliwLe6IwpsZrlpwny+ensLZeZC+yhwEwPz2Fjc1tvPziBVz+93e4AwKApWko2jaanhfrNx4exYkAUO2QZM8JBRAEAkDOz07P4Nz0dOjy2vscwg0BQha1WwFfvPRxvLu5hY9Mn2W3EITC5jYKm1vsKAHQZwTgpHYiACTGRVH7JH8C8Kev/H5XmTrrvHi7jI3bO7h67SaPaREC+bFxLC8sYG5m/FifSAWFW6WOz8u2fZeqHgbKiQAsjBgdPz734Tw+86lL0QjPc6GJhkxPaHDbJFceItVaDeubt/BfhSIuPjePmYkzvNyJZEf5fTE2MA3eCF6++hYKP7vdcU/R6T81HhgA5vwnluGKbs3zRMYXABpNfAiLA6BLZlfq68XG//S5oqiwHQ+myJFpQuX1v7n8+AF4+aVlPDuTZwBC5ynndz1Q7RMEr+1CESM7UsBxANzDqEb9oQgeQSAAhWIJl//jegjhkSkgb2hs4CNrn0pEozpyutsIAqvR+wCwWw48AUAbNtA45E+SIZAb4ZlWXAWPBMCsoSGbUEH1eO5DU/jUb1wQMWwgcKMapCRIFxMk2rAOx2nBPRTJ0KEL3+MOk7N0NOgeuxHya4m8gAZXZIYAefVHq9jYLmPcAN6zPVS9/uYI+m4DjgMgxjShAxIAOU/my3mApg3v0IWqAFLyrObbDgwzFUGgEWbbZ6PLXgA0lTu+bveXFvcNYGnEwF7bh5pQ8enfvIDZ/BQrCAHwD1vwDx3oqTSgaZDOSwAeTYIeekwZvhvAbtagD/OcTxOOSoLOQTOaW3icFHAvAMzRwxa00TRUXQ1DgJwmBRAAMjpXxZyf57ag6UkYBgfhHIgwcO1odikGYGN7B1d/dBOPTAHzIvvzh3xcfOECZp7mCjBGurL3JJ8nCGu0yduHSmkbuYkpoF3v+Lz7hNoMaeWdXRiiO9wuVfCfP16DlQDqbR/FPkeGfYfAvQDs3Kli7MkMK3exVEV+hlJibk7TYc5Lyz2ZOjEAcp4g9GMnApDTNJTbTocC6iI/L1eqrDw10d/Lws2czXeW86gzi3MOeXhsb/GUV9F54zc+lmPHXgpYPcEkad8AyPmcrqM7BApFXrvlO3u8wLqKW5vRkHhsJMmlT9PcdDxyUNmpsPNKuYKdPZ4gSTNGeGo8Ns4B5J+e4IBiIfBIAFAh5nM5aAcNLJ5fxOQkL1ht30G1Wg1ftXYUwwwIOXGWj/TyZ6fgizW/TRok/W/5roGNkQDSIylYoylYIymMj/E2prxTxerqe3BMA7UDB/VWf+OBvhVwHICNrVLoPN2jnBplBa5WeS1LAOQ82YMAkGrIj0/CGlExPpYJAZSH0Lfz9NwTAVh+Oo/aXrlDAXEAmUwGuQ/NMuffW19DJpNDTkiaADAI9RobHksFpJ/i6hibnMLqtXcwbvFGsrbfYEp4ejzdAcDIprF6uxwLmod7eyIA9woBKgYB2LxTwZ6o/XOz86j93yZzXCpAAqD7CUIVOhae/1WUb28zAHNPTTKP6k2eF0gA9J5CoNYOHh2ApZk8Zn9hHLmchdwZ3t+7baBZ5317g45doWmNWTBHUjBHeGg4+1XYYjxPR8eJFk5q9Sp0PYVGIxobpE/zxpCsWKqg5jhYvcWn2/qxEymAfvArn73EfjcOIGWl0ajXOAgxmqN7Rk9bMMUUOkGw9xsdAEzDQMMJUK/zHoQAEJtUKoXUKR4KmspHleR8etTEt37wVj9+h985MYAv/trSXQogAKG1O8sXzvAIAGrbRkUohgCoRpo5HloittDAFOOg3uBzgbWmjcs/vvFoAVx6Zg7z81FyY6V5KEgIjd0aUukISBwA3efUyywE6CUBSI8YiHsAIBWs/LTwaAHMTebw8sJ8WAjd4ikwGcnc6hobFLfKyMeyQcfh7cX2bT7PZ2gmUqc4sMYHNVAiWGs2w2c6fpTyrqyuoSCSqH4pnDgEkAD++KXl8Pc9MWFBzpNZpgFzNAW72YDdaMJuK3cBkM7T/W7LQyplMQgEwD7gztdFQ2iIQRhd+9a/rpxoRpieMXAAdZKyaOGZAsxodFgplYDY6LC4VUQQRBMZU5MTqO5UMHoqzSCQEQByvia6wfExPm1e3KmAFNBf/hfpZSAA5sZ4GJAcZeJCEAiA5nMHSQHMkhZ++PZKT8VOPTUZbqAiCGTNAzt0ns4JADlfLFfY8dEDEK58SYZB24GmGdB1gx+TKtxWtIJT9YD1tVVkcmOoVnbg7EdjBetMFvnJMTj70f0+VPi0ntB2oSZ06IaJ4l4Nxd06O9IU2knsxAqYEcPU6fEc2PsYACqYmTIZAD1pQnvChO2rqO6WUa3QawdGki+sWlneeI6LjRYEgV4SgHTysQGQGk1hNDWKpJB4LwBSAVR4cp4gsNGiAMBDgzdyBCCdzYS9hgTgOAFchytCTWhMBVIBdM0YsVDY6L8r7FsBc8/ModFshACoMBcX5sOdIPEQIOfJvAMb5YbNal8aTZjW93jiQxCkAuicQYgBoGukgJVClPoSALJ+IfQFYGKCj/3JgsMoXl/+lWeprrkzI2LHqChgdXcX1UoF2nC0k7T6QQ2mGcsa2b4gF7nT0TQZZX62mCWi5ypHPn5Y3Al/X4GClOhy+4Hw0ABI+gSAar8bwOL0JCZO81iWAKot3guQ82QEYH27iMwpXnNOG8icSoNgcPORS0cAUrreAaC6b2OtEk2kEgAyglDaKaGxHw2cQkr3ePPQAKT0eylg4nQKs0/mkJa1T+6oOnNeAmgcIeYsmAIi5wlcGrnTfKRIINSuveyFO1VU7KjllwD6hfBQAKgPtiwrrP1uBdD5wlPjyIuegdWnACCBFe9wJUinSQHSSAmU6UoAdF3mFfahB9o7XNjtnEaPA+gHwkMBmPvFBTi1OtyAj9k9n7bEdW58zBtJ5OfmQqfYHmExU+xQI1jjbcaOzOHF1lm6NvZkjjWqZizd3aM9djHb6bEXQFEUtsDCFlnEwkrxAXuGBwaQOmVhYiqPhpjd6QVg6fwSLr10CSv/HFu/lys8bLXnZAA+87u/hxtrN3H9v691QJEA6CINluRcQ2WnczdJr6bggQFQ7Tc+qANixwbVPplUADn/6pdfReGnhWMBsAIGQLnMw4BZtBuenWbFThD5sVTA3EcXQACsrIU3//KNDggEgD1qSGUAyORg7H5KeCAAYe13AYjL/7U/fA3nnz+PK6L2i3KcLhRAo7hkTNq9aoOutep1HNg2bBE2BICcf/ajH2NfOb/8Aq5fv4Y3/+KNniroBlDeKbJJlOPsgQB09Ps+38Pis12ePlvsXHx+Ca+88iq7vvLdb8Oo7rL3yWoFN8RCx5ks7+/17FhHWZzumKZMsV7DXo03dlNpA+mJKdRK2/jYb/8O5n7pPLv+zb96Ezf+5zrtoYmeN6RCEXuQVFWFqqhssbVUKnU03PECPBCAeNfntbn0yXl2DHy88gevYXGRFywOgM4r1QreLRTDOUMlPl1GDalYKZaFUl2fOU8QzuXzeAJOTwA3blzHN7/xZicAeghtt9WjjUe+CAmC0MseGkDgB8fWfi8AGHJR2aszCMy6ZojkhglZOC1QmfMZK41s2sLERDQLnH/uQqiAUAU3bwKiMtgzggCKqkAqwPVcUPJ2nAruC+CuzC8GgH7vl59bDOVP51feWYH1/rsxWfJukiDs7tXwk+K9p7CNhBE6TxCM2DayngBWfwKIbhnUDdIudKEACgEJgDLXXiq4L4CpySnoCZ39l0fKPy6lv/27f4QtRmumYcIurWP97X8Jb6F1ArKG46DpOPAdH6W9Km7v8qlvmQjJhGcsbSKVNJB6gi+Kym329H75y3/OpsmdVgMtMVX2ta/+UYeyZe2T9JkKdJNNv1Ov0KtHuC+AuZm50MFeAL7x13+PA8eGJrbCpQyNAahurbOCUY2S89L8NhgAaY3Y5AddSyW10Pk4gNzsRzD/yS+gXuPOEwSy1//s9Z4A6CJBkHunjssNjgVAy1pkuXSOAejlPCU9Fz/9W+wzAkCWEeMACYEASAWwQsVSXwIh/wojvZD/n5TnpADpPF3rBrB6bRVXvn8lhEAKIKPaZwqjP2OJ0SKdd6vgLgDkOL2ymSz2qnsIaBOTkDg5GQdBAJZf4itDcQXI0lz7hzeYAsLaphDoWiipi0WROIDRZPQd6ibnP/l55Gb51Pv9ALCyxNoAiN+XYVC+XUS86w0BZLIZ0Ct7hi9GMlrvF8KlKFZ7Rz6C2D64sfExfOWrX2f3UjtBpogeiHZ91fd2UP7+P4XPYzXieGiJ9T96T7PI0oxhDdZoZ2r47Oe+xAZgVGhW8DbQatksrSbbuLWN73zn2+Ez5H+KfKEAVew0VYc09u8Te58Pu2kPA9nQ0oWlrgGnwRoNNo+/3wwByH4/DoAU8OsfvxgqgCDEATCHS5sovv1vYQHJaTKCEAdAzhu6DmM4GvzMv/gFpM5OhzXWC8B3v3cFa2trHQA8TYcS+FApBxCbryUAY1hh6pZ2FwB7X3RbZbFHJ55psW422s1MAM6/sMz2AjPp0ZydSokIlzCpgHZ41LfuhiABOLE+PA4gNz2P+Rc/D6fNa55eLVKAaNVIAU7LxtWVtzoAKAp3XCqAykEq8I9ctgYx+gSfa5AQhmafme1QQDLJZ2OkAiiGZdobd57ukQB4CNCGaA6AwRAQUmJhhCDUtjZQ39oIw4AUIAFw5wmkA+k8Pae+Xw8V0AuAlR3H177+Jx0KkM4HisqUQEbOa6oJUgDJXzby/w9sR1xUscAthAAAAABJRU5ErkJggg=="

    local img_txd = CreateRuntimeTxd("img_txd")
    local img_tex = CreateRuntimeTexture(img_txd, "img_tex", 64, 64)
    SetRuntimeTextureBase64(img_tex, imageBase64, 64, 64)

    AddTextEntry("IMG_FEED_TEST", "")
    BeginTextCommandThefeedPost("IMG_FEED_TEST")
    EndTextCommandThefeedPostMessagetext("img_txd", "img_tex", false, 4, "Base64 image to", "runtime texture")
end)
