def Mapper(jsmr_context, data):
    counts_map = eval(data)  # makes a dict (associative array)
    for key in counts_map:
        jsmr_context.Emit(key.lower(),counts_map[key])
