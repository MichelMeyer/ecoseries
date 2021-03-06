#' A function to extract IPEA series using their API
#' @param arg1 ipea series number.
#' @param ... More series number.
#' @param periodicity A string specifying the periodicity.
#' @param save A string specifying if data should be saved in csv or xlsx format. 
#' Defaults to not saving.
#' @keywords ipea ipeadata
#' @export
#' @import rvest xml2 stats utils
#' @importFrom readr read_csv write_csv
#' @examples
#' # ipea=series_ipeadata(162225812, periodicity = c("D")) 


series_ipeadata <- function(arg1, ..., periodicity = c("Y","D", 'M', 'Q'), save = ""){
    
    inputs = as.character(list(arg1, ...))
    serie = mapply(paste0, "serie_", inputs, USE.NAMES = FALSE)

    
    
    len = seq_along(inputs)
    for (i in len){
        aux1 <- aux_ipeadata(inputs[i], periodicity = periodicity[i])
        assign(serie[i], aux1)
    }
    rm(aux1)
    
    
    if (save != ""){
        if (save == "csv"){
            for(i in len) {readr::write_csv(eval(as.symbol(serie[i])), 
                                            file = paste0(serie[i], ".csv"))}
        } 

        if (requireNamespace("xlsx", quietly = TRUE)) {                    
            if (save == "xls" | save == "xlsx") {
                for(i in len) {xlsx::write.xlsx(eval(as.symbol(serie[i])), 
                                file = paste0(serie[i], ".xlsx"), 
                                row.names = FALSE)}} else{
                                stop("save argument must be 'csv' or 'xlsx' ")}
        }
    }
    
    lista = list()
    ls_df = ls()[grepl('data.frame', sapply(ls(), function(x) class(get(x))))]
    for ( obj in ls_df ) { lista[obj]=list(get(obj)) }
    
    return(invisible(lista))
    
}