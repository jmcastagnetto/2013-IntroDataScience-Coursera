# Python Mapper - consumes 1 JSON record at a time
# and emits counts by key (Apples/Bananas/Cherries),
# for summing by the Reducer.
def Mapper(jsmr_context, data):
    counts_map = eval(data)  # makes a dict (associative array)
    for key in counts_map:
        for c in key:
            jsmr_context.Emit(c,1)
