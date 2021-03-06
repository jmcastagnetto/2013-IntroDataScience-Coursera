# Python Reducer - called once for each unique key,
# emitted by the Mappers; sums counts by key (Apples/Bananas/Cherries).
def Reducer(jsmr_context, key):
    sum = 0
    while jsmr_context.HaveMoreValues():
        count_str = jsmr_context.GetNextValue() # value always in string form
        count = int(count_str) # convert to int for summing
        sum += count
    output_str = "{'%s':%d}" % (key, sum)
    jsmr_context.Emit(output_str)
